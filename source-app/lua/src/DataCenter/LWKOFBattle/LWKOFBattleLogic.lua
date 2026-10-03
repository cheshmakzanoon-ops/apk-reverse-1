local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local LWKOFBattleLogic = BaseClass("LWKOFBattleLogic", base)
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local Time = _ENV.Time
local SkirmishSceneData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Squad = require("Scene.LWBattle.BarrageBattle.Squad")
local BattleEnumType = require("DataCenter.LWBattle.BattleEnumType")
local LINEUP_ENEMY_OFFSET = Vector3.New(36, 0, 30.19)
local GameObject = CS.UnityEngine.GameObject

function LWKOFBattleLogic:Enter(param)
  self.param = param
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(2)
  self.levelId = param.levelId
  self.sceneId = param.sceneId
  self.squadIndex = 1
  if self.param.type == PVEType.KOF then
    self.squadIndex = param.extraData.squadIndex
  end
  self.sceneData = SkirmishSceneData.New()
  self.sceneData.MAX_MINION_PER_HERO = 0
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), self.sceneId)
  local sceneName = sceneMeta.asset
  self.sceneData.sceneName = sceneName
  self.sceneData.enterType = self.param.enterType
  
  function self.onCreateComplete()
    self:LoadSceneComplete()
  end
  
  CommonUtil.ClearGameBgMusicData()
  DataCenter.LWSoundManager:PlayPveSceneBGMusicLW()
  self.LINEUP_ENEMY_OFFSET = LINEUP_ENEMY_OFFSET
end

function LWKOFBattleLogic:__delete()
  self:Destroy()
end

function LWKOFBattleLogic:Destroy()
  if self.delayEvents then
    for _, v in pairs(self.delayEvents) do
      v:Stop()
    end
  end
  self:ClearAllFormingEffects()
  self.delayEvents = {}
  self.delayActions = {}
  self:UnInitCamera()
  self:RemoveListeners()
  self:DestroyFakeEnemy()
  if self.squad then
    self.squad:Delete()
    self.squad = nil
  end
  self.touchCamera = nil
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
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
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
end

function LWKOFBattleLogic:LoadSceneComplete()
  self:OnGameStart()
end

function LWKOFBattleLogic:OnGameStart()
  if self.param.type == PVEType.KOF then
    if self.param.extraData.openWindow then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, EnterHeroSquadPanelWay.KOFAttack, self.param.extraData, nil, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWKOFCampaign)
      end)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, EnterHeroSquadPanelWay.KOFAttack, self.param.extraData)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWKOFCampaign)
    end
  end
end

function LWKOFBattleLogic:LoadScene(callBack)
  self.nextObjId = 1
  self:LineupLoadScene(callBack)
  self:CreateSquad()
  self:CreateFakeEnemy()
  self:AddListeners()
end

function LWKOFBattleLogic:OnSwitchTeam(teamIndex)
  self.squadIndex = teamIndex
  self:CreateSquad()
  self:CreateFakeEnemy()
  EventManager:GetInstance():Broadcast(EventId.KOFBattleLogicSwitchTeamEnd, teamIndex)
end

function LWKOFBattleLogic:AddListeners()
  if self.onSwitchTeamCallBack == nil then
    self.onSwitchTeamCallBack = BindCallback(self, self.OnSwitchTeam)
  end
  EventManager:GetInstance():AddListener(EventId.KOFBattleSwitchTeam, self.onSwitchTeamCallBack)
end

function LWKOFBattleLogic:RemoveListeners()
  if self.onSwitchTeamCallBack ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.KOFBattleSwitchTeam, self.onSwitchTeamCallBack)
    self.onSwitchTeamCallBack = nil
  end
end

function LWKOFBattleLogic:LineupLoadScene(callBack)
  local sceneName = self.sceneData.sceneName
  self.sceneLoadRequest = {}
  local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneName))
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    local x, y, z = self.sceneData.scenePosOffset:Split()
    z = z - 8
    sceneRoot:Set_position(x, y, z)
    if self.onCreateComplete then
      self.onCreateComplete()
      self.onCreateComplete = nil
    end
    if callBack then
      callBack()
    end
  end)
  table.insert(self.sceneLoadRequest, req)
  self.staticMgr:Append(string.format(PVEDecorationPath, sceneName), 0)
end

function LWKOFBattleLogic:InitCamera()
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  self.hudCamera = self.camera.transform:Find("HudCamera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.touchCamera.CanMoveing = false
  self.saveCameraParam = {}
  self.saveCameraParam.fieldOfView = self.camera.fieldOfView
  self:InitCameraParams()
  local touchInput = self.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function LWKOFBattleLogic:UnInitCamera()
  if self.touchCamera then
    self.touchCamera.CanMoveing = true
    local touchInput = self.touchCamera.touchInput
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
    self.camera.fieldOfView = self.saveCameraParam.fieldOfView
    self.hudCamera.fieldOfView = self.saveCameraParam.fieldOfView
    self.touchCamera.AfterUpdate = nil
    self.touchCamera = nil
  end
end

function LWKOFBattleLogic:InitCameraParams()
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

function LWKOFBattleLogic:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function LWKOFBattleLogic:GetFollowCameraTarget()
  return self.followCameraTarget
end

function LWKOFBattleLogic:CameraFollowLookat(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offset = targetPos - self.followCameraTarget
  transform:Set_position(x + offset.x, y + offset.y, z + offset.z)
  self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
end

function LWKOFBattleLogic:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function LWKOFBattleLogic:CreateSquad()
  local objId = self:GetNextObjId()
  local squadData
  if self.param.type == PVEType.KOF then
    squadData = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(self.squadIndex)
  end
  local allHeroes = {}
  if squadData ~= nil then
    local heroes = squadData:GetAllHeroes()
    for slotIndex, heroUuid in pairs(heroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        allHeroes[slotIndex] = heroData
      end
    end
    if self.squad then
      self.squad:ChangeHeroes(allHeroes)
    else
      local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
      local weaponSkinId = DataCenter.TacticalWeaponManager:GetWeaponSkinId()
      local appearanceId = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(weaponInfo, weaponSkinId)
      self.squad = Squad.New(self, objId, allHeroes, nil, nil, weaponInfo, appearanceId)
      self.squad:OnCreate()
      self.squad:InitPosition(self.sceneData.armyBirthPos[1])
    end
  end
end

function LWKOFBattleLogic:CreateFakeEnemy()
  self:DestroyFakeEnemy()
  if self.param.type == PVEType.KOF then
    self:CreateFakeEnemyFromArena3V3Data()
  end
end

function LWKOFBattleLogic:CreateFakeEnemyFromArena3V3Data()
  local armyInfo = DataCenter.LWKOFBattleManager:GetOpponentDefenceTeam(self.squadIndex)
  local heroes = {}
  if armyInfo ~= nil then
    local uuids = armyInfo:GetAllHeroes()
    for index, uuid in pairs(uuids) do
      local heroData = armyInfo:GetHeroDataByUuid(uuid)
      if heroData ~= nil then
        heroes[index] = heroData
      end
    end
    local dominatorData = armyInfo:GetDominatorData()
    if dominatorData then
      heroes[ArmyFormationSlot.Dominator] = dominatorData
    end
  end
  self.sceneData:InitData(false, heroes[ArmyFormationSlot.Dominator] ~= nil)
  if heroes ~= nil then
    local go = GameObject("ArmyRoot")
    self.armyRoot = go
    local armyRootTransform = go.transform
    local pos = LINEUP_ENEMY_OFFSET + self.sceneData.scenePosOffset
    armyRootTransform:Set_position(pos.x, 0, pos.z)
    armyRootTransform:Set_eulerAngles(0, 180, 0)
    self.platoonGoList = {}
    self.heroDataList = {}
    self.heroReqList = {}
    self.qualitySlots = {}
    for i = 1, ArmyFormationSlot.Dominator do
      local index = i + 5
      if i == ArmyFormationSlot.Dominator then
        index = PVPBattleSlot.EnemyDominator
        if heroes[i] == nil then
          goto lbl_226
        end
      end
      local platoonGo = GameObject("PlatoonRoot")
      self.platoonGoList[i] = platoonGo
      local platoonTransform = platoonGo.transform
      platoonTransform:SetParent(armyRootTransform)
      platoonTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local localPosition = self.sceneData.platoonLocalPos[index]
      platoonTransform:Set_localPosition(localPosition.x, localPosition.y, localPosition.z)
      local sprite
      if i < ArmyFormationSlot.Dominator then
        local obj = CS.UnityEngine.GameObject("QualitySlot" .. i)
        obj.transform:SetParent(self.platoonGoList[i].transform, false)
        obj.transform:Set_localEulerAngles(90, 0, 0)
        obj.transform.localPosition = Vector3.New(0, 0.2, 0)
        obj.transform.localScale = Vector3.New(1.5, 1.5, 1)
        sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        self.qualitySlots[i] = sprite
      end
      local heroInfo = heroes[i]
      if heroInfo then
        local hero = HeroInfo.New()
        self.heroDataList[i] = hero
        hero:UpdateFromMailData(heroInfo.heroId, heroInfo.heroLevel, {}, heroInfo.weaponLevel, heroInfo.rankLv, heroInfo.awakenLv, heroInfo.heroSkinId)
        local modelPath, appearanceId, modelSourceType = hero:GetHeroModelData(HeroModelType.Battle)
        if not string.IsNullOrEmpty(modelPath) and appearanceId ~= nil then
          local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
          local path = modelPath
          self.heroReqList[i] = Resource:InstantiateAsync(path)
          self.heroReqList[i]:completed("+", function(request)
            local gameObject = request.gameObject
            local transform = gameObject.transform
            transform:SetParent(self.platoonGoList[i].transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            transform:Set_localPosition(0, 0, 0)
            transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
            local animator = gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
            if not IsNull(animator) then
              animator:Play(AnimName.Idle)
            end
          end)
          if sprite then
            sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", hero.meta.quality))
          end
        end
      elseif sprite then
        sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
      end
      ::lbl_226::
    end
  end
  local weaponInfo = DataCenter.LWKOFBattleManager:GetOpponentWeaponInfo()
  if weaponInfo ~= nil and self.armyRoot ~= nil then
    local armyRootTransform = self.armyRoot.transform
    self.opponentWeaponGo = nil
    self.opponentWeaponInfo = nil
    self.opponentWeaponReq = nil
    local index = 12
    local weaponGo = GameObject("WeaponRoot")
    self.opponentWeaponGo = weaponGo
    local weaponTransform = weaponGo.transform
    weaponTransform:SetParent(armyRootTransform)
    weaponTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local localPosition = self.sceneData.platoonLocalPos[index]
    weaponTransform:Set_localPosition(localPosition.x, localPosition.y, localPosition.z)
    local weaponInfoIns = TacticalWeaponInfo.New()
    weaponInfoIns:CreateFromTemplate(weaponInfo.id, weaponInfo.lv)
    local skinId = weaponInfo.uavSkinId
    local appearanceId = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(weaponInfoIns, skinId)
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    if appearanceMeta then
      do
        local path = appearanceMeta.model_path
        self.opponentWeaponReq = Resource:InstantiateAsync(path)
        self.opponentWeaponReq:completed("+", function(request)
          local gameObject = request.gameObject
          local transform = gameObject.transform
          transform:SetParent(self.opponentWeaponGo.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          transform:Set_localPosition(0, 0, 0)
          transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
        end)
      end
    end
  end
  if not self.allUnits then
    self.allUnits = {}
  end
  for i = 1, ArmyFormationSlot.Dominator do
    local pvpSlot = self.sceneData.FormationSlot2PVPSlot(i, false)
    if self.heroDataList[i] then
      self.allUnits[pvpSlot] = self.heroDataList[i]
    else
      self.allUnits[pvpSlot] = nil
    end
  end
  self:RefreshBattleEffect()
end

function LWKOFBattleLogic:DestroyFakeEnemy()
  if self.heroDataList then
    for k, v in pairs(self.heroDataList) do
      self.heroDataList[k]:Delete()
    end
    self.heroDataList = nil
  end
  if self.heroReqList then
    for k, v in pairs(self.heroReqList) do
      self.heroReqList[k]:Destroy()
    end
    self.heroReqList = nil
  end
  if self.platoonGoList then
    for i = 1, #self.platoonGoList do
      CS.UnityEngine.GameObject.Destroy(self.platoonGoList[i])
    end
    self.platoonGoList = nil
  end
  if self.opponentWeaponReq then
    self.opponentWeaponReq:Destroy()
    self.opponentWeaponReq = nil
  end
  if self.opponentWeaponGo then
    CS.UnityEngine.GameObject.Destroy(self.opponentWeaponGo)
    self.opponentWeaponGo = nil
  end
  if self.armyRoot then
    CS.UnityEngine.GameObject.Destroy(self.armyRoot)
    self.armyRoot = nil
  end
  if self.qualitySlots then
    for _, v in pairs(self.qualitySlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.qualitySlots = nil
  end
end

function LWKOFBattleLogic:SetSquadCreateFinishFlag(state)
  self.squadCreateFinish = state
end

function LWKOFBattleLogic:OnSquadCreateFinish()
  self.squadCreateFinish = true
  EventManager:GetInstance():Broadcast(EventId.OnBattleSquadCreateFinish)
end

function LWKOFBattleLogic:GetSquadMemberPosition()
  if self.squad then
    return self.squad:ReturnMemberPositions()
  else
    return {}
  end
end

function LWKOFBattleLogic:GetEnemyMemberPosition()
  local pos = {}
  if self.platoonGoList ~= nil then
    for i = 1, 5 do
      table.insert(pos, self.platoonGoList[i].transform:TransformPoint(0, -0.6, 0))
    end
  end
  return pos
end

function LWKOFBattleLogic:SetHeroers(heroes)
  if self.squad then
    self.squad:ChangeHeroes(heroes)
  end
  if not self.allUnits then
    self.allUnits = {}
  end
  for i = 1, ArmyFormationSlot.Dominator do
    local pvpSlot = self.sceneData.FormationSlot2PVPSlot(i, true)
    if heroes[i] then
      self.allUnits[pvpSlot] = heroes[i]
    else
      self.allUnits[pvpSlot] = nil
    end
  end
  self:RefreshBattleEffect()
end

function LWKOFBattleLogic:SetHeroPos(index, pos)
  if self.squad then
    self.squad:SetHeroPosition(index, pos)
  end
  if self.sourceEffects and self.sourceEffects[index] then
    for _, v in pairs(self.sourceEffects[index]) do
      v:UpdateStartPos(pos)
    end
  end
  if self.targetEffects and self.targetEffects[index] then
    for _, v in pairs(self.targetEffects[index]) do
      v:UpdateTargetPos(pos)
    end
  end
end

function LWKOFBattleLogic:ResetHeroPos()
  if self.squad then
    self.squad:ResetHeroPosition()
  end
end

function LWKOFBattleLogic:OnDragHeroEnd(dragHeroIdx)
  if self.squad then
    self.squad:ResetHeroPosition()
    if self.sourceEffects and self.sourceEffects[dragHeroIdx] then
      for _, v in pairs(self.sourceEffects[dragHeroIdx]) do
        v:UpdateStartPos(v:GetStartIdxPos())
        v:ReplayDstEffect()
      end
    end
    if self.targetEffects and self.targetEffects[dragHeroIdx] then
      for _, v in pairs(self.targetEffects[dragHeroIdx]) do
        v:UpdateTargetPos(v:GetTargetIdxPos())
      end
    end
  end
end

function LWKOFBattleLogic:HeroMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.5
  if self.squad then
    self.squad:MoveHeroToIndex(index, dstIndex, animTime)
  end
end

function LWKOFBattleLogic:OnFingerDown()
end

function LWKOFBattleLogic:OnFingerUp()
end

function LWKOFBattleLogic:OnUpdateSec()
  self.useTime = self.useTime + 1
end

function LWKOFBattleLogic:AfterExit()
  if self.param.type == PVEType.KOF then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWKOFCampaign)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation, {anim = false})
  self.mainUI = nil
end

function LWKOFBattleLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function LWKOFBattleLogic:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function LWKOFBattleLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function LWKOFBattleLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function LWKOFBattleLogic:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function LWKOFBattleLogic:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function LWKOFBattleLogic:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function LWKOFBattleLogic:Lookat(lookWorldPosition)
  local cameraOffset = Vector3.New(0, 0, 4.1)
  self.followCameraTarget = Vector3.New(lookWorldPosition.x, lookWorldPosition.y, lookWorldPosition.z)
  self.touchCamera:LookAt(lookWorldPosition + cameraOffset)
end

function LWKOFBattleLogic:GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function LWKOFBattleLogic:GetPVEType()
  return PVEType.KOF
end

function LWKOFBattleLogic:Exit()
  self.battleMgr:Exit()
end

function LWKOFBattleLogic:GetMailUuid()
  if self.battleData and self.battleData.extData then
    return self.battleData.extData.uuid
  end
  return nil
end

local ObjectPoolIns = ObjectPool:GetInstance()

function LWKOFBattleLogic:RefreshBattleEffect()
  if not self.allUnits then
    self:ClearAllFormingEffects()
  end
  local validEffects = {}
  for idx, hero in pairs(self.allUnits) do
    local skills = hero:GetAllSkillsReadOnly()
    for _, skill in pairs(skills) do
      if skill:IsUnlock() then
        local template = skill:GetTemplateData()
        local formingEffect = template:GetFormingEffect()
        if not table.IsNullOrEmpty(formingEffect) then
          for i = 1, #formingEffect do
            local effect = formingEffect[i]
            local displayType, targetEffect, lineEffect = effect.displayType, effect.targetEffect, effect.lineEffect
            if BattleEnumType.inverseBattleFormingEffect[displayType] then
              if not self.targetEffClsMap then
                self.targetEffClsMap = {}
              end
              if not self.targetEffClsMap[displayType] then
                self.targetEffClsMap[displayType] = require(BattleEnumType.BattleFormingEffectClass[displayType])
              end
              local cls = self.targetEffClsMap[displayType]
              local oppositePos = cls.GetOppositeIdx(self.sceneData, self.allUnits, idx)
              if not oppositePos then
                break
              end
              local oppositeHero = self.allUnits[oppositePos]
              if not oppositeHero then
                break
              end
              local hash = cls.GetHash(idx, oppositePos, targetEffect, lineEffect)
              if self.m_formingEffects and self.m_formingEffects[hash] then
                validEffects[hash] = self.m_formingEffects[hash]
                break
              end
              local effectInfo = ObjectPoolIns:Load(cls)
              effectInfo:Init(idx, oppositePos, targetEffect, lineEffect, self)
              effectInfo:Load()
              validEffects[hash] = effectInfo
              if not self.m_formingEffects then
                self.m_formingEffects = {}
              end
              self.m_formingEffects[hash] = effectInfo
              if not self.sourceEffects then
                self.sourceEffects = {}
              end
              if not self.sourceEffects[idx] then
                self.sourceEffects[idx] = {}
              end
              self.sourceEffects[idx][hash] = effectInfo
              if not self.endEffects then
                self.endEffects = {}
              end
              if not self.endEffects[oppositePos] then
                self.endEffects[oppositePos] = {}
              end
            end
          end
        end
      end
    end
  end
  if self.m_formingEffects then
    for hash, effect in pairs(self.m_formingEffects) do
      if not validEffects[hash] then
        local srcIdx = effect.srcIdx
        local targetIdx = effect.dstIdx
        if effect then
          effect:Delete()
          ObjectPoolIns:Save(effect)
        end
        self.m_formingEffects[hash] = nil
        if self.sourceEffects[srcIdx] and self.sourceEffects[srcIdx][hash] then
          self.sourceEffects[srcIdx][hash] = nil
        end
        if self.endEffects[targetIdx] and self.endEffects[targetIdx][hash] then
          self.endEffects[targetIdx][hash] = nil
        end
      end
    end
  end
end

function LWKOFBattleLogic:ClearAllFormingEffects()
  if not table.IsNullOrEmpty(self.m_formingEffects) then
    for hash, effectInfo in pairs(self.m_formingEffects) do
      effectInfo:Delete()
      ObjectPoolIns:Save(effectInfo)
    end
    self.m_formingEffects = nil
    self.sourceEffects = nil
    self.endEffects = nil
    self.targetEffClsMap = nil
  end
end

return LWKOFBattleLogic
