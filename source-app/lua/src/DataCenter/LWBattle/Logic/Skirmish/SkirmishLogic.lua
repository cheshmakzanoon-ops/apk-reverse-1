local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local SkirmishLogic = BaseClass("SkirmishLogic", base)
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local Time = _ENV.Time
local rapidjson = require("rapidjson")
local Army = require("Scene.LWBattle.Skirmish.Army")
local SkirmishSceneData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData")
local SkirmishBattleData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishBattleData")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local ULTIMATE_ADVANCE_OFFSET = 0.5
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

function SkirmishLogic:Enter(param)
  self.battleMgr = DataCenter.LWBattleManager
  self.battleData = SkirmishBattleData.New(param.mailExtData)
  self.sceneData = SkirmishSceneData.New(self.battleData:SelfHaveDominator(), self.battleData:EnemyHasDominator())
  self.param = param
  self.levelId = param.levelId
  self.battleMgr.cameraOffset:Set(0, 0, 0)
  self:ChangeStage(SkirmishStage.Load)
  self.bulletManager = BulletManager.New(self)
  self.damageTextMgr = DamageTextManager.New()
  self.effectObjMgr = EffectObjManager.New(self)
  self.prevActIndex = 0
  self.useTime = 0
  self.startFrame = Time.frameCount
  self.killNum = 0
  self.unitMgr = UnitManager.New(self)
  self.unitGuid = 0
  self.delayEvents = {}
  self.__event_handlers = {}
  self.pauseBattleTimer = nil
  CommonUtil.ClearGameBgMusicData()
  DataCenter.LWSoundManager:PlayParkourBattleBGMusic()
  self.delayActions = {}
  self.captains = {}
end

function SkirmishLogic:__delete()
  self:Destroy()
end

function SkirmishLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
  local touchInput = self.battleMgr.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function SkirmishLogic:UnInitCamera()
  if self.touchCamera and self.touchCamera.touchInput then
    local touchInput = self.touchCamera.touchInput
    self.touchCamera.CanMoveing = true
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
    self.onFingerDown = nil
    self.onFingerUp = nil
  end
end

function SkirmishLogic:OnFingerDown()
end

function SkirmishLogic:OnFingerUp()
end

function SkirmishLogic:InitCameraParams()
  local height = self.sceneData.OPENING_CAMERA_HEIGHT
  local fov = self.sceneData.OPENING_CAMERA_FOV
  local rotation = self.sceneData.OPENING_CAMERA_ROTATION
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = self:GetOffsetZ(height, rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = 10
  self.camera.transform.eulerAngles = Vector3.New(rotation, 0, 0)
end

function SkirmishLogic:GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function SkirmishLogic:UpdateCameraFollow()
end

function SkirmishLogic:ShakeCameraWithParam(param)
  self.battleMgr:ShakeCameraWithParam(param)
end

function SkirmishLogic:LoadScene(callBack)
  self.captains = {}
  self.armys = {}
  self.armys[1] = Army.New(self, 1, self.sceneData, self.battleData)
  self.armys[2] = Army.New(self, 2, self.sceneData, self.battleData)
  self.sceneResLoaded = false
  self.remotePackDownloadRecord = {}
  self.remotePackDownloadRecord.map = {}
  self.remotePackDownloadRecord.count = 0
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(2)
  self.damageTextMgr:Init(self)
  self.sceneLoadRequest = {}
  local req = Resource:InstantiateAsync(string.format(PVEScenePath, self.sceneData.sceneName), ObjectPoolTag.BattleScene)
  req:completed("+", function()
    self.sceneResLoaded = true
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_position(self.sceneData.scenePosOffset:Split())
    if self.remotePackDownloadRecord and #self.remotePackDownloadRecord > 0 then
      return
    end
    self:OnSceneLoaded(callBack)
  end)
  table.insert(self.sceneLoadRequest, req)
  self.staticMgr:Append(string.format(PVEDecorationPath, self.sceneData.sceneName), 0)
  for _, v in pairs(self.battleData.heroData) do
    if v and 0 < v.weaponLevel then
      local heroId = v.heroId
      local packConfigId = LocalController:instance():getValue("lw_hero", heroId, "download_packs_id")
      if packConfigId and 0 < packConfigId and not ResGroupManager:IsDownload(packConfigId) then
        do
          local loader = ResGroupManager:StartDownload(packConfigId)
          loader:completed("+", function(loaderReq)
            if not ResGroupManager:IsDownload(packConfigId) then
              Logger.LogError("pack\228\184\139\232\189\189\229\174\140\228\185\139\229\144\142\230\156\172\229\156\176\230\178\161\230\137\190\229\136\176\239\188\159\239\188\159 packConfigId: " .. packConfigId)
            end
            self.remotePackDownloadRecord.map[packConfigId] = nil
            self.remotePackDownloadRecord.count = self.remotePackDownloadRecord.count - 1
            if self.remotePackDownloadRecord.count <= 0 and self.sceneResLoaded then
              self:OnSceneLoaded(callBack)
            end
          end)
          self.remotePackDownloadRecord.map[packConfigId] = loader
          self.remotePackDownloadRecord.count = self.remotePackDownloadRecord.count + 1
        end
      end
    end
  end
end

function SkirmishLogic:OnSceneLoaded(callBack)
  if callBack then
    callBack()
  end
  self:ChangeStage(SkirmishStage.Opening)
end

function SkirmishLogic:OnUpdate()
  if self.fightPause == true then
    return
  end
  self.bulletManager:OnUpdate()
  self.effectObjMgr:OnUpdate()
  self.damageTextMgr:OnUpdate()
  if self.armys then
    self.armys[1]:OnUpdate()
    self.armys[2]:OnUpdate()
  end
  if self.stage == SkirmishStage.Fight then
    self:OnUpdateFight()
  end
  self.unitMgr:OnUpdate()
  self:OnUpdateDoDelayAction()
end

function SkirmishLogic:OnUpdateSec()
  self.useTime = self.useTime + 1
end

function SkirmishLogic:DealDamage(params)
  local defender = params.defender
  local hitPoint = params.hitPoint
  local hitDir = params.hitDir
  local whiteTime = params.whiteTime
  local stiffTime = params.stiffTime
  local hitBackDistance = params.hitBackDistance
  local hitEff = params.hitEff
  local skill = params.skill
  defender:AfterBeAttack(0, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
end

function SkirmishLogic:ShowDamageText(damage, position, style, damageType, isCritical, time)
  local param = self.damageTextMgr:GetParam()
  param.damage = damage
  param.position = position
  param.style = style
  param.damageType = damageType
  param.isCritical = isCritical
  param.time = time
  self.damageTextMgr:GenText(param)
end

function SkirmishLogic:ShowBuffText(txt, position, isDebuff, iconPath, time)
  local param = self.damageTextMgr:GetParam()
  param.txt = txt
  param.position = position
  param.style = DamageTextType.GetBuff
  param.isDebuff = isDebuff
  param.iconPath = iconPath
  param.time = time
  param.damage = 0
  self.damageTextMgr:GenText(param)
end

function SkirmishLogic:ShowEffectText(txt, position, style, isDebuff, time, combo)
  local param = self.damageTextMgr:GetParam()
  param.txt = txt
  param.position = position
  param.style = style
  param.isDebuff = isDebuff
  param.time = time
  param.damage = 0
  param.combo = combo or 0
  self.damageTextMgr:GenText(param)
end

function SkirmishLogic:Destroy()
  if self.remotePackDownloadRecord then
    for i, v in pairs(self.remotePackDownloadRecord.map) do
      self.remotePackDownloadRecord.map[i] = nil
    end
    self.remotePackDownloadRecord = nil
  end
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  self.delayActions = {}
  if self.pauseBattleTimer ~= nil then
    self.pauseBattleTimer:Stop()
    self.pauseBattleTimer = nil
  end
  self:UnInitCamera()
  self.touchCamera = nil
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  self.captains = {}
  if self.armys then
    for _, v in pairs(self.armys) do
      v:Destroy()
    end
    self.armys = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Destroy()
    self.damageTextMgr = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
  self.battleData = nil
end

function SkirmishLogic:AfterExit()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishMain, {anim = false})
  self.mainUI = nil
end

function SkirmishLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function SkirmishLogic:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function SkirmishLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function SkirmishLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function SkirmishLogic:ShowEffectObj(path, pos, rot, time, parent, type, isImportant, callback)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type, isImportant, callback)
end

function SkirmishLogic:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function SkirmishLogic:IsEffectValid(id)
  return self.effectObjMgr:IsEffectValid(id)
end

function SkirmishLogic:ReplayEffect(id, time)
  self.effectObjMgr:ReplayEffect(id, time)
end

function SkirmishLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function SkirmishLogic:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function SkirmishLogic:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function SkirmishLogic:GetTotalKill()
  return self.killNum
end

function SkirmishLogic:GetFightDuration()
  return self.battleData.fightDuration
end

function SkirmishLogic:GetWatchTime()
  return self.useTime
end

function SkirmishLogic:GetAvgFPS()
  if self.useTime == 0 then
    return -1
  end
  return (Time.frameCount - self.startFrame) / self.useTime
end

function SkirmishLogic:ChangeStage(newStage, param)
  local oldStage = self.stage
  if newStage == SkirmishStage.Load then
    self.stage = newStage
  elseif newStage == SkirmishStage.Opening then
    if oldStage ~= SkirmishStage.Load then
      return
    end
    self.stage = newStage
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISkirmishMain) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
      self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UISkirmishMain).View
    end
    self.battleMgr:LookAt(self.sceneData.camPoint)
    self.battleMgr:SetGameStart(true)
    self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT, self.sceneData.OPENING_TIME)
    self:AddDelayEvent(function()
      self:ChangeStage(SkirmishStage.Fight)
    end, self.sceneData.OPENING_TIME)
  elseif newStage == SkirmishStage.Fight then
    if oldStage ~= SkirmishStage.Opening then
      return
    end
    self.stage = newStage
    self.fightTime = 0
    EventManager:GetInstance():Broadcast(EventId.SkirmishFightStage)
  elseif newStage == SkirmishStage.End then
    if oldStage ~= SkirmishStage.Opening and oldStage ~= SkirmishStage.Fight then
      return
    end
    local popDelay = param or 3
    self.stage = newStage
    EventManager:GetInstance():Broadcast(EventId.SkirmishEndStage)
    self:AddDelayEvent(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishResult, {anim = false}, param)
    end, popDelay)
  end
  if self.armys then
    for _, army in pairs(self.armys) do
      army:ChangeStage(newStage)
    end
  end
end

function SkirmishLogic:SetMinionFightPause(isPause)
  for _, army in pairs(self.armys) do
    for _, platoon in pairs(army.platoons) do
      for _, minion in pairs(platoon.minions) do
        minion:SetMinionFightPause(isPause)
      end
    end
  end
end

function SkirmishLogic:SetCaptainFightPause(isPause)
  self.fightPause = isPause
  if not isPause then
    if self.stage ~= SkirmishStage.Fight then
      self.stage = SkirmishStage.Fight
      self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT)
    end
    if self.armys then
      for _, army in pairs(self.armys) do
        army:ChangeStage(SkirmishStage.Fight)
      end
    end
    if self.prevActIndex <= 0 then
      self.fightTime = 0
    else
      self.fightTime = self.battleData.actions[self.prevActIndex].time
    end
  end
end

function SkirmishLogic:ReDo()
  if self.prevActIndex >= #self.battleData.actions then
    return nil
  end
  self:DoAction(self.prevActIndex + 1)
  self.prevActIndex = self.prevActIndex + 1
  return true
end

function SkirmishLogic:UnDo()
  if self.prevActIndex <= 0 then
    return nil
  end
  self:UnDoAction(self.prevActIndex)
  self.prevActIndex = self.prevActIndex - 1
  return true
end

function SkirmishLogic:UnReDo()
  return self:UnDo() and self:ReDo()
end

function SkirmishLogic:OnUpdateFight()
  if self.fightPause then
    return
  end
  if self.prevActIndex >= #self.battleData.actions then
    self:ChangeStage(SkirmishStage.End)
    return
  end
  local oldFightTime = self.fightTime
  self.fightTime = self.fightTime + Time.deltaTime
  for i = self.prevActIndex + 1, #self.battleData.actions do
    if self.battleData.actions[i].time < self.fightTime then
      self:DoAction(i)
      self.prevActIndex = i
    else
      break
    end
  end
  local oldAdvanceTime = oldFightTime + ULTIMATE_ADVANCE_OFFSET
  local advanceTime = self.fightTime + ULTIMATE_ADVANCE_OFFSET
  for i = self.prevActIndex + 1, #self.battleData.actions do
    if oldAdvanceTime > self.battleData.actions[i].time then
    elseif advanceTime > self.battleData.actions[i].time then
      self:CheckUltimateBubble(i)
    else
      break
    end
  end
end

function SkirmishLogic:CheckUltimateBubble(index)
  local curAction = self.battleData.actions[index]
  if curAction.phase == ActionPhase.Cast then
    local caster = self.captains[curAction.casterIndex]
    local isUltimateSkill = false
    if caster then
      local skillInfo = caster:GetSkillInfo(curAction.skillId)
      if skillInfo then
        isUltimateSkill = skillInfo:IsUltimateSkill()
      end
    end
    if curAction.casterIndex <= 5 and isUltimateSkill then
      EventManager:GetInstance():Broadcast(EventId.SkirmishUltimateBubble, curAction)
    end
  end
end

function SkirmishLogic:DoAction(index)
  local curAction = self.battleData.actions[index]
  self:LogAction(curAction)
  if curAction.phase == ActionPhase.Cast or curAction.phase == ActionPhase.FIRE_BULLET or curAction.phase == ActionPhase.SPLASH_DAMAGE or curAction.phase == ActionPhase.SkillCast or curAction.phase == ActionPhase.Bounce then
    self.captains[curAction.casterIndex]:DoAction(curAction)
  elseif curAction.phase == ActionPhase.Buff then
    local skillLv = 1
    local skillId = curAction.skillId
    local casterIndex = curAction.casterIndex
    if skillId and 0 < skillId and casterIndex and 0 < casterIndex then
      local unit = self:GetCaptain(casterIndex)
      if unit and unit.heroData then
        if unit.heroData.skillLevels then
          skillLv = unit.heroData.skillLevels[skillId]
        elseif unit.heroData.skillInfos then
          for _, v in pairs(unit.heroData.skillInfos) do
            if v.skillId == skillId then
              skillLv = v.skillLv
              break
            end
          end
        end
      end
    end
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v, skillLv)
    end
  elseif curAction.phase == ActionPhase.Dot then
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v)
    end
  elseif curAction.phase == ActionPhase.Damage or curAction.phase == ActionPhase.ShieldDamage then
    if #curAction.targets == 1 then
      self.captains[curAction.targets[1].index]:DoAction(curAction, curAction.targets[1])
    elseif 1 < #curAction.targets then
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(curAction.skillId)
      local effectId = curAction.effectId
      if effectId == 0 then
        effectId = curAction.skillId * 10
      end
      local skillEffectMeta = DataCenter.SkillEffectPvpTemplateManager:GetTemplate(effectId)
      if skillEffectMeta and skillEffectMeta.pvp_bullet == 0 and skillEffectMeta.pvp_actionType == SkillActionType.NoBulletDamage then
        for _, v in pairs(curAction.targets) do
          self.captains[v.index]:DoAction(curAction, v)
        end
      else
        if skillEffectMeta == nil or 0 >= skillEffectMeta.pvp_bullet then
          Logger.LogError("skill effect meta is nil or bulletId is <=0,  effectId:" .. tostring(curAction.effectId))
          return
        end
        local bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(skillEffectMeta.pvp_bullet)
        local bullet_row_count = bulletMeta.bullet_row_count_replay
        local bullet_wave_count = bulletMeta.bullet_wave_count_replay
        local bullet_diff_time = bulletMeta.bullet_diff_time_replay
        local bullet_wave_diff_time = bulletMeta.bullet_wave_diff_time_replay
        if bullet_row_count == 1 and bullet_wave_count == 1 then
          for _, v in pairs(curAction.targets) do
            self.captains[v.index]:DoAction(curAction, v)
          end
        else
          local hitsClientConfig = bullet_wave_count * bullet_row_count
          local hitsServerConfig = skillEffectMeta.pvp_cast_count
          local totalTargets = #curAction.targets
          local hitIndex = 0
          local targetIndex = 0
          local delayTime = 0
          local targetPerHits = math.ceil(totalTargets / hitsServerConfig)
          for i = 0, bullet_wave_count - 1 do
            for j = 0, bullet_row_count - 1 do
              delayTime = bullet_wave_diff_time * i + bullet_diff_time * j
              for k = 1, targetPerHits do
                targetIndex = targetIndex + 1
                if curAction.targets[targetIndex] then
                  curAction.targets[targetIndex].delayTime = delayTime
                else
                  goto lbl_270
                end
              end
              hitIndex = hitIndex + 1
            end
          end
          ::lbl_270::
          for i = targetIndex + 1, totalTargets do
            if curAction.targets[i] then
              curAction.targets[i].delayTime = delayTime
            end
          end
          curAction.pastIndex = 0
          curAction.pastTime = 0
          table.insert(self.delayActions, curAction)
        end
      end
    end
  elseif curAction.phase == ActionPhase.REMOVE_BUFF then
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v)
    end
  elseif curAction.phase == ActionPhase.SummonPet then
    for _, v in pairs(curAction.summonUnit) do
      local petInfo = DeepCopy(v)
      if self.battleData:NeedSwap() then
        petInfo.index = self.battleData.Swap(petInfo.index)
      end
      local index = petInfo.index
      local armyIndex = 5 < index and 2 or 1
      self.armys[armyIndex]:CreatePet(petInfo)
    end
  elseif curAction.phase == ActionPhase.BeforeHeroAwakenSkillCast then
    local isSelfHero = curAction.casterIndex <= PVPBattleSlot.SelfHero5
    if isSelfHero then
      self.captains[curAction.casterIndex]:DoAction(curAction)
      self:SetGamePauseForTime(1)
      EventManager:GetInstance():Broadcast(EventId.SkirmishCastHeroAwakenSkill, self.captains[curAction.casterIndex])
    end
  end
  if CommonUtil.IsDebug() then
    EventManager:GetInstance():Broadcast(EventId.SkirmishDoAction, curAction)
  end
end

function SkirmishLogic:OnUpdateDoDelayAction()
  for i = #self.delayActions, 1, -1 do
    local action = self.delayActions[i]
    if action.pastIndex >= #action.targets then
      table.remove(self.delayActions, i)
    else
      action.pastTime = action.pastTime + Time.deltaTime
      for j = action.pastIndex + 1, #action.targets do
        local target = action.targets[j]
        if target.delayTime and target.delayTime <= action.pastTime then
          self.captains[target.index]:DoAction(action, target)
          action.pastIndex = j
        else
          action.pastIndex = j - 1
          break
        end
      end
    end
  end
end

function SkirmishLogic:DoDelayActionInstantly()
  for i = #self.delayActions, 1, -1 do
    local action = self.delayActions[i]
    for j = action.pastIndex + 1, #action.targets do
      local target = action.targets[j]
      self.captains[target.index]:DoAction(action, target)
    end
    table.remove(self.delayActions, i)
  end
end

function SkirmishLogic:UnDoAction(index)
  local curAction = self.battleData.actions[index]
  if curAction.phase == ActionPhase.Cast then
    self.captains[curAction.casterIndex]:UnDoAction(curAction)
  elseif curAction.phase == ActionPhase.Damage or curAction.phase == ActionPhase.Dot then
    self:DoDelayActionInstantly()
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:UnDoAction(curAction, v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SkirmishUnDoAction, curAction)
end

function SkirmishLogic:LogAction(action)
  if self.canOutputLog == nil then
    self.canOutputLog = CS.CommonUtils.IsDebug()
  end
  if not self.canOutputLog then
    return
  end
  local jsonData = rapidjson.encode(action)
  Logger.Log(jsonData .. "uuid" .. self.battleData.extData.uuid)
end

function SkirmishLogic:ErrorAction(action)
  local jsonData = rapidjson.encode(action)
  Logger.LogError(jsonData .. "uuid" .. self.battleData.extData.uuid)
end

function SkirmishLogic:AddCaptain(index, captain)
  self.captains[index] = captain
end

function SkirmishLogic:GetCaptain(index)
  if self.captains[index] then
    return self.captains[index]
  else
    return nil
  end
end

function SkirmishLogic:OnCaptainDeath()
end

function SkirmishLogic:GetRandomTargetPos(index)
  return self.armys[index % 2 + 1]:GetRandomPosition()
end

function SkirmishLogic:GetPVEType()
  return PVEType.Skirmish
end

function SkirmishLogic:Exit()
  if self.param.enterType == PVEEnterType.Mail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.History)
  end
  self.battleMgr:Exit()
end

function SkirmishLogic:GetMailUuid()
  if self.battleData and self.battleData.extData then
    return self.battleData.extData.uuid
  end
  return nil
end

function SkirmishLogic:JumpToEnd()
  self:ChangeStage(SkirmishStage.End, 0)
end

local MAX_OPENNING_ACTION_COUNT = 80

function SkirmishLogic:UnitHaveOpenningSkill(unitIndex)
  if not self.battleData or not self.battleData.actions then
    return false
  end
  local actions = self.battleData.actions
  local actionCount = #actions
  local unitActionCount = 0
  for i = 1, actionCount do
    local action = actions[i]
    if 2 <= unitActionCount or i >= MAX_OPENNING_ACTION_COUNT then
      return false
    end
    if action.casterIndex == unitIndex then
      unitActionCount = unitActionCount + 1
      if action.phase == ActionPhase.SkillCast then
        local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(action.skillId)
        if skillMeta and not table.IsNullOrEmpty(skillMeta.moving_logic) then
          local isOpeningClip = skillMeta.moving_logic[1].type == SkillMovingLogicType.TeamZeroPos or skillMeta.moving_logic[1].type == SkillMovingLogicType.PlayAnimation
          if isOpeningClip then
            return true
          end
        end
      end
    end
  end
end

function SkirmishLogic:SetGamePause(isPause)
  self:SetCaptainFightPause(isPause)
  self:SetMinionFightPause(isPause)
end

function SkirmishLogic:SetGamePauseForTime(time)
  local leftPauseTime = time
  if self.pauseBattleTimer ~= nil then
    leftPauseTime = leftPauseTime + checknumber(self.pauseBattleTimer.left)
    self.pauseBattleTimer:Stop()
    self.pauseBattleTimer = nil
  end
  if 0 < leftPauseTime then
    self:SetGamePause(true)
    self.pauseBattleTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:SetGamePause(false)
    end, leftPauseTime)
  end
end

function SkirmishLogic:IsGamePaused()
  return self.fightPause == true
end

return SkirmishLogic
