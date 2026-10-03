local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local GhostParkourPlaybackLogic = BaseClass("GhostParkourPlaybackLogic", base)
local GhostParkourData = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourData")
local SurfingScene = require("DataCenter.LWBattle.Logic.Surfing.SurfingScene")
local GhostParkourSceneData = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourSceneData")
local GhostParkourPBPlayerUnit = require("Scene.LWBattle.GhostParkour.GhostParkourPBPlayerUnit")
local Const = require("Scene.LWBattle.Const")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")
local math_tan = math.tan
local math_pi = math.pi
local defaultFov = 40
local defaultHeight = 8.5
local defaultRotation = 16
local LineOffset = 4
local TouchThreshold = 20
local RenderOffsetInterval = 64000
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local SkyboxPath = "Assets/Main/Prefabs/BountyHunter/Scene/LastWar_Scene_skybox_pk.prefab"

function GhostParkourPlaybackLogic:__init()
  if DataCenter.LWBattleManager.lineOffset then
    TouchThreshold = DataCenter.LWBattleManager.touchThreshold
  end
  self.isPlayback = true
  self.goods = {}
  self.energyNum = -23
  self.staticEffectCommonPos = Vector3.zero
  self.speedChangeTime = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k13", 1)
  self.renderOffsetZ = 0
  self.loadingFinishMark = 0
  self.loadingFlag = 0
  self.playerCount = 0
  self.curEnergy = 0
  self.start = nil
end

function GhostParkourPlaybackLogic:__delete()
  self:Destroy()
end

function GhostParkourPlaybackLogic:Enter(param)
  self.battleMgr = DataCenter.LWBattleManager
  local qualityLevel = GameQualitySettings.GetQualityByConfigLevel()
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  self.ignoreSpectacularEffect = deviceLevel < EDeviceLevel.Mid and qualityLevel < 4
  self.lowDevice = deviceLevel < EDeviceLevel.MidLow
  self.ultraLowDevice = deviceLevel < EDeviceLevel.Low
  self.isDecorationMeshOpen = LuaEntry.DataConfig:CheckSwitch("surfing_decoration_instance_test")
  PveUnitViewUtil.InitView()
  EffectViewUtil.InitView()
  self.isDebug = CS.CommonUtils.IsDebug()
  self.isEditor = CS.UnityEngine.Application.isEditor
  self.waitingLoad = nil
  self.unitGuid = 0
  self.unitMgr = UnitManager.New(self)
  self:InitMonsterManager()
  self.__event_handlers = {}
  self.param = param
  local lane = 1
  if param then
    self:InitData(param)
    if param.message and param.message.matchList and param.message.matchList[1] then
      lane = param.message.matchList[1].lane
    else
      lane = param.lane or 1
    end
  end
  self.playbackType = param.playbackType or 1
  self.curLine = self:GetCurLine(lane)
  self.scenes = {}
  self.speedZ = self.data and self.data:GetMoveSpeed() or 0
  self.endLine = nil
  local pos = self:GetBirthPos(self.curLine)
  self.birthPos = pos
  self.skyBoxX = pos.x
  self.totalRunTime = 0
  self.totalPauseTime = 0
  self.checkTimer = 0
  self:ChangeState(Const.SurfingState.Ready)
  local id = self.data and self.data.meta and self.data.meta.bgm
  if not string.IsNullOrEmpty(id) then
    self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(tonumber(id), true, true)
  end
  _, self.needEnergy = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  self:AddListeners()
end

function GhostParkourPlaybackLogic:GetPVEType()
  return PVEType.GhostParkour
end

function GhostParkourPlaybackLogic:OnUpdate()
  local deltaTime = 0
  if self.isDebug and self.isEditor then
    deltaTime = Time.deltaTime
  else
    deltaTime = Time.unscaledDeltaTime
  end
  if self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Entrance then
    return
  end
  self.totalRunTime = self.totalRunTime + deltaTime
  ProfilerUtil.BeginSample("GhostParkourPlaybackLogic.OnUpdate.CheckLoadedCount")
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId, objHandle = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded(false, objHandle)
      end
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("GhostParkourPlaybackLogic.OnUpdate.UpdateScene")
  self:UpdateScene()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("GhostParkourPlaybackLogic.OnUpdate.PlayerUpdate")
  if self.player then
    self.player:OnUpdate(deltaTime, self.totalRunTime)
  end
  if self.ghostPlayers then
    for _, v in pairs(self.ghostPlayers) do
      if v then
        v:OnUpdate(deltaTime, self.totalRunTime)
      end
    end
  end
  ProfilerUtil.EndSample()
  EffectViewUtil.Update(deltaTime)
  ProfilerUtil.BeginSample("GhostParkourPlaybackLogic.OnUpdate.MonsterMgrUpdate")
  if self.monsterMgr ~= nil then
    local viewY = self:GetCurDistanceData()
    self.monsterMgr:Update(viewY, deltaTime)
  end
  ProfilerUtil.EndSample()
  self:UpdateSkybox()
end

function GhostParkourPlaybackLogic:Destroy()
  self:RemoveListeners()
  self:CloseWindows()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  CS.SceneManager.ResetRollStrengthZ()
  self:UnInitCamera()
  PveUnitViewUtil.UnInitView()
  EffectViewUtil.UnInitView()
  self:RemoveSceneUpdator()
  self:RemoveLateUpdate()
  if self.waitingTimer then
    self.waitingTimer:Stop()
    self.waitingTimer = nil
  end
  if self.sceneExtReq then
    self.sceneExtReq:Destroy()
    self.sceneExtReq = nil
  end
  if self.skyboxReq then
    self.skyboxReq:Destroy()
    self.skyboxReq = nil
  end
  self.skyboxTrans = nil
  self.skyboxValid = false
  if self.scenes then
    for i, v in ipairs(self.scenes) do
      if v then
        v:OnDestroy()
      end
    end
    self.scenes = nil
  end
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.monsterMgr then
    self.monsterMgr:Destroy()
    self.monsterMgr = nil
  end
  self.speedZ = nil
  self.endLine = nil
  self.goods = nil
  self.energyNum = nil
  self.waitingLoad = nil
  self.loadingFinishMark = nil
  self.loadingFlag = nil
  self.playerCount = nil
  if self.data then
    self.data:Delete()
    self.data = nil
  end
  self.start = nil
  self.startLoading = nil
end

function GhostParkourPlaybackLogic:InitMonsterManager()
  local SurfingMonsterManager = require("Scene.LWBattle.Surfing.Monster.SurfingMonsterManager")
  self.monsterMgr = SurfingMonsterManager.New()
end

function GhostParkourPlaybackLogic:InitData(param)
  if param then
    local levelId = param.levelId
    local gm = param.enterType == PVEEnterType.GM
    self.gm = gm
    self.data = GhostParkourData.New(self, levelId, param)
  end
end

function GhostParkourPlaybackLogic:LoadScene(callBack)
  self.loadingFlag = self.loadingFlag + 1
  local error = self:LoadPlayer()
  if error then
    self:OnBeKickedFromGame()
    return
  end
  if self.isDecorationMeshOpen or self.isDebug and GMUtils.GetBool(GMConst.NewPVEDecorationShowMethod, false) then
    self.staticMgr = CS.PVEStaticDecorationManager()
  else
    self.staticMgr = CS.PVEStaticManager()
  end
  self.staticMgr:InitLW(20, 5)
  self.staticMgr:SetVisibleChunk(3)
  self.staticMgr:SetChunkUnloadEnable(true)
  self.monsterMgr:Init(self)
  self:LoadSkybox()
  self:LoadSceneExt()
  self:PreloadUnit()
  self:PreloadEffect()
  local loadingView = self.battleMgr.uiPveLoading
  if loadingView then
    loadingView:SetOnClosed(function()
      if self.initComplete then
        self:OnShowPlayerInfo()
      else
        self.waitingLoad = true
      end
    end)
  end
  self.data:PreloadScenes(function()
    self:LoadSceneByCount(4, function()
      if callBack then
        callBack()
      end
      self:CheckLoadFinish()
      self:LoadSceneComplete()
    end)
  end)
  self:OnStartWaitLoading()
  CS.SceneManager.SetRollStrengthZ(0.6)
  CS.SceneManager.SetRollStrengthX(0, -18, 0.8)
end

function GhostParkourPlaybackLogic:GetCurLine(lane)
  local curLine = 0
  if lane == nil then
    return curLine
  end
  if lane == 0 then
    curLine = -1
  elseif lane == 1 then
    curLine = 0
  elseif lane == 2 then
    curLine = 1
  end
  return curLine
end

function GhostParkourPlaybackLogic:GetBirthPos(curLine)
  local defaultPos = self.data:GetBirthPos()
  if defaultPos then
    local x = defaultPos.x + curLine * LineOffset
    return Vector3.New(x, defaultPos.y, defaultPos.z)
  end
end

function GhostParkourPlaybackLogic:CheckLoadFinish(value)
  value = value or 1
  if self.loadingFinishMark then
    self.loadingFinishMark = self.loadingFinishMark + value
    if self.loadingFinishMark >= self.loadingFlag then
      self:LoadComplete()
    end
  end
end

function GhostParkourPlaybackLogic:OnStartWaitLoading()
  if self.isGuide then
    return
  end
  local waitLoadingParam = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config_c", "k10", "")
  local arr = string.split(waitLoadingParam, "|")
  local time = 0
  if arr and 0 < #arr then
    time = tonumber(arr[1]) or 0
  end
  self.startLoading = time
  
  function self.waitingCallback()
    self:OnWaitingUpdate()
  end
  
  self.waitingTimer = TimerManager:GetInstance():GetTimer(0.2, self.waitingCallback, self, false, false, false)
  self.waitingTimer:Start()
end

function GhostParkourPlaybackLogic:OnWaitingUpdate()
  if self.showPlayInfo or self.waitPause then
    return
  end
  if self.startLoading then
    self.startLoading = self.startLoading - 0.2
    if self.startLoading <= 0 then
      self.waitingTimer:Stop()
      self.waitingTimer = nil
      self.startLoading = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourWaitLoading, {anim = true})
    end
  end
end

function GhostParkourPlaybackLogic:LoadComplete()
  self.initComplete = true
  if self.waitingLoad then
    self.waitingLoad = nil
    self:OnShowPlayerInfo()
  end
end

function GhostParkourPlaybackLogic:UpdateMonsterMgr(sceneCfg)
  if sceneCfg and not string.IsNullOrEmpty(sceneCfg.farmMonster) then
    self.monsterMgr:ReInit(sceneCfg.farmMonster, sceneCfg.offset, sceneCfg.groupId)
  end
end

function GhostParkourPlaybackLogic:LoadPlayer()
  if self.birthPos == nil then
    self.birthPos = self:GetBirthPos(self.curLine)
  end
  if self.param == nil or self.param.message == nil then
    Logger.LogError("GhostParkour -- [LoadPlayer] data error")
    return true
  end
  local message = self.param.message
  local firstInfo = message.firstInfo
  if firstInfo == nil then
    Logger.LogError("GhostParkour -- [LoadPlayer] firstInfo is nil")
    return true
  end
  local uid = firstInfo.uid
  if uid == nil or uid == 0 or uid == "" then
    Logger.LogError("GhostParkour -- [LoadPlayer] firstInfo.uid error")
    return true
  end
  local uuid = firstInfo.uuid
  if uuid == nil or uuid == 0 then
    Logger.LogError("GhostParkour -- [LoadPlayer] firstInfo.uuid error")
    return true
  end
  local rank = 1
  if firstInfo.flag then
    rank = firstInfo.flag == 1 and 1 or 2
  end
  self.loadingFlag = self.loadingFlag + 2
  self.playerCount = self.playerCount + 1
  self.player = GhostParkourPBPlayerUnit.New()
  local error = self.player:Init(self, firstInfo, self.data:GetHeroId(), self.speedChangeTime, 1, true)
  if error then
    return error
  else
    self:AddUnit(self.player)
  end
  local otherInfo = message.otherInfo
  if not table.IsNullOrEmpty(otherInfo) then
    self.loadingFlag = self.loadingFlag + 2
    self.playerCount = self.playerCount + 1
    local player = GhostParkourPBPlayerUnit.New()
    error = player:Init(self, otherInfo, self.data:GetHeroId(), self.speedChangeTime, 2)
    if error then
      otherInfo.markFlag = 1
    else
      self:AddUnit(player)
      self.ghostPlayers = {player}
    end
  end
  self.rank = rank
end

function GhostParkourPlaybackLogic:AddListeners()
  self:AddListener(EventId.Guide_video_Play, self.OnLoadSceneFinished)
  self:AddListener(EventId.OpenUI, self.OnOpenUIAction)
  self:AddListener(EventId.CloseUI, self.OnCloseUIAction)
  self:AddListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
end

function GhostParkourPlaybackLogic:RemoveListeners()
  self:RemoveListener(EventId.Guide_video_Play)
  self:RemoveListener(EventId.OpenUI)
  self:RemoveListener(EventId.CloseUI)
  self:RemoveListener(EventId.APP_APPLICATION_PAUSE)
end

function GhostParkourPlaybackLogic:OnShowPlayerInfo()
  self.showPlayInfo = true
  if self.waitPause or self.waitingLoad then
    return
  end
  if self.waitingTimer then
    self.waitingTimer:Stop()
    self.waitingTimer = nil
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourWaitLoading) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourWaitLoading)
  end
  self.startLoading = nil
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleCountDown, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, {
    message = self.param and self.param.message,
    start = true,
    isPlayback = true
  })
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.param and self.param.message)
  self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIGhostParkourBattleMain).View
  self:ChangeState(Const.SurfingState.Entrance)
end

function GhostParkourPlaybackLogic:OnStart()
  self.start = true
  self:RemoveSceneUpdator()
  if self.mainUI then
    self.mainUI:OnStart()
  end
  self:ChangeState(Const.SurfingState.Surfing)
  DataCenter.LWSoundManager:PlaySound(11004, false)
  self.battleMgr:SetGameStart(true)
end

function GhostParkourPlaybackLogic:ChangeState(newState)
  local oldState = self.state
  if newState == Const.SurfingState.Ready then
    self.state = newState
  elseif newState == Const.SurfingState.Entrance then
    self.state = newState
    self.player:ChangeState(Const.SurfingState.Entrance)
    if self.ghostPlayers then
      for _, v in pairs(self.ghostPlayers) do
        if v then
          v:ChangeState(Const.SurfingState.Entrance)
        end
      end
    end
  elseif newState == Const.SurfingState.Surfing then
    self.state = newState
    self.player:ChangeState(Const.SurfingState.Surfing)
    if self.ghostPlayers then
      for _, v in pairs(self.ghostPlayers) do
        if v then
          v:ChangeState(Const.SurfingState.Surfing)
        end
      end
    end
  elseif newState == Const.SurfingState.Win then
    if oldState ~= Const.SurfingState.Surfing then
      return
    end
    self.state = newState
    if self.mainUI then
      self.mainUI:OnNitrogenSpeedUpFinished()
    end
    self.battleMgr:SetGameOver(true)
    self:EndGame()
  elseif newState == Const.SurfingState.Pause then
    if oldState ~= Const.SurfingState.Entrance and oldState ~= Const.SurfingState.Surfing or oldState == newState then
      return
    end
    self.battleMgr:SetGamePause(true)
    self.state = newState
  end
end

function GhostParkourPlaybackLogic:CloseWindows()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleMain) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleMain)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleCountDown) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleCountDown)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELoading)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourWaitLoading)
end

function GhostParkourPlaybackLogic:GetOffsetZ(height, rotation)
  return height / math_tan(rotation * math_pi / 180)
end

function GhostParkourPlaybackLogic:AddLateUpdate()
  if self.lateUpdateTimer == nil then
    function self.lateUpdateTimer()
      self:OnLateUpdate()
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateTimer)
  end
end

function GhostParkourPlaybackLogic:RemoveLateUpdate()
  if self.lateUpdateTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateTimer)
    self.lateUpdateTimer = nil
  end
end

function GhostParkourPlaybackLogic:OnLateUpdate()
  if not self.battleMgr:IsPlayingShakeCamera() then
    local deltaTime = 0
    if self.isDebug and self.isEditor then
      deltaTime = Time.deltaTime
    else
      deltaTime = Time.unscaledDeltaTime
    end
    self:UpdateCameraFollow(deltaTime)
  end
  if not self.lowDevice and self.touchCamera and self.staticMgr then
    CS.CSUtils.UpdatePVEStaticMgrWithRealPos(self.touchCamera, self.staticMgr, 30, self.renderOffsetZ)
  end
end

function GhostParkourPlaybackLogic:EndGame()
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourPlaybackEnd) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourPlaybackEnd)
  end
  if self.param and self.param.message and self.param.message.firstInfo then
    local firstInfo = self.param.message.firstInfo
    local score = firstInfo.score
    if self.mainUI then
      self.mainUI:SyncTime(score)
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourPlaybackEnd, {anim = true}, {
      totalRunTime = score / 1000,
      rank = self.rank
    })
  else
    Logger.LogError("GhostParkour -- [EndGame] param error")
  end
end

function GhostParkourPlaybackLogic:OnBeKickedFromGame(tipsId)
  tipsId = tipsId or "parkour_cheat_01"
  DataCenter.LWBattleManager:SetGameOver(true)
  DataCenter.LWBattleManager:ShowTipsId(tipsId)
  if self.battleMgr then
    self.battleMgr:Exit(nil, "lose")
  end
end

function GhostParkourPlaybackLogic:GetSwitchMonsterId()
  return self.data:GetSwitchMonsterId()
end

function GhostParkourPlaybackLogic:CheckOffsetZ(newZ)
  if RenderOffsetInterval <= 0 then
    return newZ, false
  end
  if newZ >= RenderOffsetInterval then
    self.renderOffsetZ = self.renderOffsetZ - RenderOffsetInterval
    newZ = newZ - RenderOffsetInterval
    return newZ, true
  end
  return newZ, false
end

function GhostParkourPlaybackLogic:ApplyResetOffsetZ()
  local cameraTransform = self.touchCamera.transform
  if IsNotNull(cameraTransform) then
    local x, y, z = cameraTransform:Get_position()
    cameraTransform:Set_position(x, y, z - RenderOffsetInterval)
  end
  PvePhysicsUtil.ResetPlayerColliderData()
  self.monsterMgr:ResetRenderPosition()
  if self.scenes then
    for _, scene in pairs(self.scenes) do
      if scene then
        scene:ResetRenderPosition()
      end
    end
  end
  if self.staticMgr then
    self.staticMgr:SetRenderOffsetZ(self.renderOffsetZ)
  end
end

function GhostParkourPlaybackLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function GhostParkourPlaybackLogic:RemoveUnit(guid)
  self.unitMgr:RemoveUnitById(guid)
end

function GhostParkourPlaybackLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function GhostParkourPlaybackLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function GhostParkourPlaybackLogic:GetMoveSpeed()
  return self.speedZ
end

function GhostParkourPlaybackLogic:GetSpeedBoardParam()
  if self.speedBoardParam == nil then
    local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(3091)
    if buffMeta then
      local para = buffMeta.rawPara
      local arr = string.split(para, ";")
      if arr then
        self.speedBoardParam = {}
        for i, v in ipairs(arr) do
          self.speedBoardParam[i] = tonumber(v)
        end
      end
    end
  end
  return self.speedBoardParam
end

function GhostParkourPlaybackLogic:DealDamage(attacker, defender, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, exValue)
  local hurt = exValue
  if hurt <= 0 then
    return
  end
  ProfilerUtil.BeginSample("SurfingDealDamage")
  defender:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, attacker)
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("SurfingDealDamage")
  defender:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  ProfilerUtil.EndSample()
end

function GhostParkourPlaybackLogic:GetCurDistanceData()
  local z = self.player and self.player:GetPosition().z or 0
  return z - self.renderOffsetZ
end

function GhostParkourPlaybackLogic:GetPlayersPosition()
  if self.ghostPlayers then
    local posArr = {}
    local pos
    for i, v in pairs(self.ghostPlayers) do
      pos = v and v:GetPosition()
      if pos then
        local z = pos.z
        z = z - self.renderOffsetZ
        pos.z = z
      else
        pos = Vector3.New(0, 0, 0 - self.renderOffsetZ)
      end
      posArr[i] = pos
    end
    return posArr
  end
end

function GhostParkourPlaybackLogic:GetCurPos()
  return self.player and self.player:GetPosition()
end

function GhostParkourPlaybackLogic:GetCurTotalRunTime()
  return self.totalRunTime
end

function GhostParkourPlaybackLogic:GetMonster(guid)
  return self.monsterMgr:GetMonster(guid)
end

function GhostParkourPlaybackLogic:GetUuid()
  return self.param and self.param.uuid
end

function GhostParkourPlaybackLogic:RecordGoods(type, goodsId, goodsCount)
  if type == SurfingGoodsType.Energy then
    self.energyNum = self.energyNum + goodsCount
    self.curEnergy = self.curEnergy + 1
    return
  end
  if not self.goods[type] then
    self.goods[type] = {}
    self.goods[type].count = -23
    self.goods[type].id = goodsId
  end
  self.goods[type].count = self.goods[type].count + goodsCount
end

function GhostParkourPlaybackLogic:GetScoreMultiplier()
  return 1
end

function GhostParkourPlaybackLogic:OnNitrogenSpeedUp()
  self.curEnergy = 0
  if self.player then
    local buffId = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
    local buff = self.player:AddBuff(buffId)
    EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {buff = buff})
    self.player:ShowUnitEffect(SurfingUnitEffectType.GotProps)
  end
  if self.mainUI then
    self.mainUI:RefreshEnergy()
  end
end

function GhostParkourPlaybackLogic:CheckUpdateDecoration()
  if self.isDecorationMeshOpen then
    return not self.ultraLowDevice
  end
  return not self.lowDevice
end

function GhostParkourPlaybackLogic:GetNitrogenNeedEnergy()
  return self.needEnergy
end

function GhostParkourPlaybackLogic:GetNitrogenBuffSpeed()
  if self.nitrogenBuffSpeed == nil then
    local nitrogenBuffId = self:GetNitrogenBuffId()
    if nitrogenBuffId then
      local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(nitrogenBuffId)
      local para = tonumber(buffMeta.rawPara or "")
      self.nitrogenBuffSpeed = para
    end
  end
  return self.nitrogenBuffSpeed
end

function GhostParkourPlaybackLogic:GetNitrogenBuffId()
  if self.nitrogenBuffId == nil then
    self.nitrogenBuffId, self.nitrogenActiveNum = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  end
  return self.nitrogenBuffId
end

function GhostParkourPlaybackLogic:GetNitrogenActiveNum()
  if self.nitrogenActiveNum == nil then
    self.nitrogenBuffId, self.nitrogenActiveNum = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  end
  return self.nitrogenActiveNum
end

function GhostParkourPlaybackLogic:GetCurSpeed()
  return self.player and self.player:GetMoveSpeed() or self:GetMoveSpeed()
end

function GhostParkourPlaybackLogic:GetMaxMeters()
  return self.data and self.data:GetMaxMeters() or 0
end

function GhostParkourPlaybackLogic:HideGhostPlayer(index)
  if index and self.param and self.param.message then
    if index == 1 then
      self:OnBeKickedFromGame()
      return
    end
    local otherInfo = self.param.message.otherInfo
    if otherInfo then
      otherInfo.markFlag = 1
      if self.ghostPlayers then
        local player = self.ghostPlayers[1]
        if player then
          player:HideGhostPlayer()
          self.ghostPlayers[index] = nil
          self.playerCount = self.playerCount - 1
        end
      end
      self.ghostPlayers = nil
    end
  end
end

function GhostParkourPlaybackLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function GhostParkourPlaybackLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function GhostParkourPlaybackLogic:RemoveListener(msg_name)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function GhostParkourPlaybackLogic:LoadSkybox()
  if self.skyboxReq then
    return
  end
  self.skyboxReq = CS.GameEntry.Resource:InstantiateAsync(SkyboxPath, ObjectPoolTag.BattleScene)
  self.skyboxReq:completed("+", function()
    if self.skyboxReq.isError then
      return
    end
    self.skyboxTrans = self.skyboxReq.gameObject.transform
    self.skyboxValid = IsNotNull(self.skyboxTrans)
    self:UpdateSkybox()
  end)
end

function GhostParkourPlaybackLogic:UpdateSkybox()
  if self.skyboxValid and self.player then
    local pos = self.player:GetPosition()
    self.skyboxTrans:Set_localPosition(self.skyBoxX, 0, pos.z)
  end
end

function GhostParkourPlaybackLogic:LoadSceneExt()
  local sceneExt = self.data:GetSceneExt()
  if not string.IsNullOrEmpty(sceneExt) then
    self.sceneExtReq = CS.GameEntry.Resource:InstantiateAsync(sceneExt, ObjectPoolTag.BattleScene)
    self.sceneExtReq:completed("+", function()
      if self.sceneExtReq.isError then
        return
      end
      local go = self.sceneExtReq.gameObject
      if go then
        go:SetActive(true)
      end
    end)
  end
end

function GhostParkourPlaybackLogic:PreloadUnit()
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_ditiepaoku_speed_buff_1.prefab", 20)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_ditiepaoku_speed_buff_2.prefab", 20)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_paoku_01_g.prefab", 50)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Hero/A_Hero_surfing_paoku01_hong_ghost.prefab", 1)
end

function GhostParkourPlaybackLogic:PreloadEffect()
  if not self.ignoreSpectacularEffect then
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ljw_s4_running_gold_glow.prefab", 30)
  end
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV1.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV2.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV3.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_chaoji.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_xuanyun.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_fuhuo.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_chinengliang.prefab", 2)
end

function GhostParkourPlaybackLogic:LoadSceneComplete()
  if self.birthPos == nil then
    self.birthPos = self:GetBirthPos(self.curLine)
  end
  local pos = self.birthPos
  self.battleMgr:LookAt(pos)
  self:FixCameraFar()
  self:AddSceneUpdator()
  self:AddLateUpdate()
end

function GhostParkourPlaybackLogic:LoadSceneByCount(count, callBack)
  if not self.data then
    Logger.LogInfo("GhostParkour -- the logic data is nil")
    return
  end
  ProfilerUtil.BeginSample("GhostParkourPlaybackLogic.LoadSceneByCount")
  local sceneConfigs = self.data:GetSceneConfigs(count)
  if table.IsNullOrEmpty(sceneConfigs) then
    Logger.LogInfo("GhostParkour -- cannot get scene configs")
    return
  end
  local finishedScene = 0
  for _, sceneCfg in ipairs(sceneConfigs) do
    local lastData = self:GetLastSceneData()
    local lastZ = 0
    local lastIndex = -1
    if lastData then
      lastZ = lastData.endZ
      lastIndex = lastData.index
    else
      lastZ = sceneCfg.offset
    end
    local data = GhostParkourSceneData.New(sceneCfg, lastZ + sceneCfg.sizeZ, lastZ, lastIndex + 1)
    if sceneCfg.endLine and self.endLine == nil then
      self.endLine = lastZ + sceneCfg.endLine
    end
    local scene = SurfingScene.New(data, self, self.data.scenePool)
    scene:OnLoad(function()
      finishedScene = finishedScene + 1
      if finishedScene >= #sceneConfigs and callBack then
        callBack()
      end
    end)
    self:UpdateMonsterMgr(sceneCfg)
    table.insert(self.scenes, scene)
  end
  ProfilerUtil.EndSample()
end

function GhostParkourPlaybackLogic:CheckSceneData()
  return false
end

function GhostParkourPlaybackLogic:GetLastSceneData()
  if self.scenes then
    local scene = self.scenes[#self.scenes]
    if scene then
      return scene.sceneData
    end
  end
  return nil
end

function GhostParkourPlaybackLogic:UpdateScene()
  if self.scenes and self.data then
    local followZ = self:GetCurDistanceData()
    if self.curScene ~= nil and self.curScene:IsContainsZ(followZ) then
      return
    end
    local curScene
    for _, v in ipairs(self.scenes) do
      if v:IsContainsZ(followZ) then
        curScene = v
        break
      end
    end
    if curScene and self.curScene then
      local preScene = self.curScene:GetPreviousScene()
      if preScene then
        table.removebyvalue(self.scenes, preScene)
        preScene:OnDestroy()
      end
      self:LoadSceneByCount(1)
    end
    self.curScene = curScene
  end
end

function GhostParkourPlaybackLogic:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function GhostParkourPlaybackLogic:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function GhostParkourPlaybackLogic:SceneUpdate()
  if not self.touchCamera then
    return
  end
  if self.battleMgr.gameStart then
    return
  end
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId, objHandle = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded(false, objHandle)
      end
    end
  end
end

function GhostParkourPlaybackLogic:OnLoadSceneFinished()
  CS.SceneManager.SetRollStrengthZ(0.6)
  CS.SceneManager.SetRollStrengthX(0, -18, 0.8)
  self:FixCameraFar()
end

function GhostParkourPlaybackLogic:OnOpenUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      return
    end
    self:Pause(true)
  end
end

function GhostParkourPlaybackLogic:OnCloseUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect and self.endGameMsgWaiting then
    self:EndGame()
  end
end

function GhostParkourPlaybackLogic:OnApplicationPause(isPaused)
  if isPaused then
    self:Pause(true)
  elseif self.endGameMsgWaiting then
    self:EndGame()
  end
end

function GhostParkourPlaybackLogic:ShowEffectObj(path, pos, rot, time, parent, type)
  if string.IsNullOrEmpty(path) then
    return
  end
  type = type == EffectObjType.Sprite and 1 or 0
  time = time or 1
  if pos == nil and rot == nil then
    return EffectViewUtil.ShowEffectOnlyParent(path, time, type, parent)
  elseif pos == nil then
    return EffectViewUtil.ShowEffectZeroPos(path, time, type, rot, parent)
  elseif rot == nil then
    return EffectViewUtil.ShowEffectZeroRot(path, time, type, pos, parent)
  else
    return EffectViewUtil.ShowEffect(path, time, type, pos, rot, parent)
  end
end

function GhostParkourPlaybackLogic:ShowEffectParent(id, parent)
  if not id then
    return
  end
  EffectViewUtil.ShowEffectParent(id, parent)
end

function GhostParkourPlaybackLogic:ResetEffectPosition(id, x, y, z)
  if not id then
    return
  end
  EffectViewUtil.ResetPosition(id, x, y, z)
end

function GhostParkourPlaybackLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function GhostParkourPlaybackLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
end

function GhostParkourPlaybackLogic:UnInitCamera()
  self:UnInitTouchInput()
end

function GhostParkourPlaybackLogic:UnInitTouchInput()
  if self.touchCamera and self.touchCamera.touchInput then
    self.touchCamera.CanMoveing = true
  end
end

function GhostParkourPlaybackLogic:FixCameraFar()
  self.camera = self.battleMgr.camera
  if self.camera then
    self.camera.farClipPlane = 200
  end
end

function GhostParkourPlaybackLogic:InitCameraParams()
  local cameraParam = self:GetCameraParam()
  local height = cameraParam.height
  local fov = cameraParam.fov
  local cameraPos = self.touchCamera:GetCameraPos()
  cameraPos.y = height
  self.touchCamera:SetCameraPos(cameraPos)
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = self:GetOffsetZ(height, cameraParam.rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.camera.transform.eulerAngles = Vector3.New(cameraParam.rotation, 0, 0)
end

function GhostParkourPlaybackLogic:GetCameraParam()
  local fov = defaultFov
  local height = defaultHeight
  local rotation = defaultRotation
  if self.data and self.data.cameraParams and #self.data.cameraParams > 0 then
    fov = self.data.cameraParams[1]
    height = self.data.cameraParams[2]
    rotation = self.data.cameraParams[3]
  end
  local camera = {}
  camera.fov = fov
  camera.height = height
  camera.rotation = rotation
  return camera
end

local tmpV2 = Vector3.New(0, 0, 0)
local LookOffset = 13

function GhostParkourPlaybackLogic:UpdateCameraFollow(deltaTime)
  if self.state ~= Const.SurfingState.Surfing and self.state ~= Const.SurfingState.Win then
    return
  end
  local teamPosX, teamPosY, teamPosZ = self.player:GetCameraFollowXYZ()
  if teamPosZ == nil then
    return
  end
  tmpV2:Set(teamPosX, teamPosY, teamPosZ + LookOffset)
  self.battleMgr:CameraFollowLookAt(tmpV2, 8, 15, deltaTime)
end

function GhostParkourPlaybackLogic:ExitSurfing()
end

function GhostParkourPlaybackLogic:OnBuffAdd()
end

function GhostParkourPlaybackLogic:RecordBuffList(buffType, buffId, bornId, monsterId)
end

function GhostParkourPlaybackLogic:OnNitrogenSpeedUpFinished()
  if self.mainUI then
    self.mainUI:OnNitrogenSpeedUpFinished()
  end
end

function GhostParkourPlaybackLogic:OnGameFinished()
  if self.ghostPlayers then
    for _, v in pairs(self.ghostPlayers) do
      if v then
        v:ChangeToFinish()
      end
    end
  end
end

function GhostParkourPlaybackLogic:GetRankOffsetZ()
  if self.playerCount and self.playerCount > 0 then
    self.playerCount = self.playerCount - 1
    return 4 * self.playerCount
  end
  return 0
end

function GhostParkourPlaybackLogic:Pause(pause)
  if self:WaitingPause(pause) then
    return
  end
  if pause then
    self:ChangeState(Const.SurfingState.Pause)
    if self.state ~= Const.SurfingState.Pause then
      return
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleCountDown) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleCountDown)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourPause) then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourPause, {anim = true})
  elseif not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleCountDown) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleCountDown, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, {isPlayback = false, start = false})
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourOnBattlePaused, pause)
end

function GhostParkourPlaybackLogic:WaitingPause(pause)
  if self.startLoading or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourWaitLoading) then
    self.waitPause = pause
    if pause then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourPause, {anim = true})
    elseif self.showPlayInfo then
      self:OnShowPlayerInfo()
    end
    EventManager:GetInstance():Broadcast(EventId.GhostParkourOnBattleWaitingPaused, pause)
    return true
  end
  return false
end

function GhostParkourPlaybackLogic:ContinueGame()
  self.battleMgr:SetGamePause(false)
  self:ChangeState(Const.SurfingState.Surfing)
  if not self.start then
    self:OnStart()
  end
end

return GhostParkourPlaybackLogic
