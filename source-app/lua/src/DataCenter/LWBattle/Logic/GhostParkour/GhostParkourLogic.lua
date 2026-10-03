local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local GhostParkourLogic = BaseClass("GhostParkourLogic", base)
local GhostParkourData = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourData")
local SurfingScene = require("DataCenter.LWBattle.Logic.Surfing.SurfingScene")
local GhostParkourSceneData = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourSceneData")
local GhostParkourPlayerUnit = require("Scene.LWBattle.GhostParkour.GhostParkourPlayerUnit")
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
local CheckInterval = 5
local RenderOffsetInterval = 64000
local FPS_SAMPLE_CD = 10
local PC_OP_Interval = 4
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local SkyboxPath = "Assets/Main/Prefabs/BountyHunter/Scene/LastWar_Scene_skybox_pk.prefab"
local GuideOpType = {
  Up = 1,
  Down = 2,
  Left = 3,
  Right = 4,
  Finish = 5,
  DoubleClick = 6,
  Click = 7,
  PickEnergyL = 8,
  PickEnergyR = 9
}

function GhostParkourLogic:__init()
  if DataCenter.LWBattleManager.lineOffset then
    TouchThreshold = DataCenter.LWBattleManager.touchThreshold
  end
  self.goods = {}
  self.buffList = {}
  self.energyNum = -23
  self.staticEffectCommonPos = Vector3.zero
  self.speedChangeTime = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config", "k13", 1)
  self.vibrationDuration = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k9", 3)
  self.vibrationTimer = -self.vibrationDuration
  self.renderOffsetZ = 0
  self.frames = 0
  self.frameTimer = 0
  self.sampleCd = FPS_SAMPLE_CD
  self.sampleFrame = Time.frameCount
  self.lowestFps = 999
  self.loadingFinishMark = 0
  self.loadingFlag = 0
  self.curEnergy = 0
  self.start = nil
end

function GhostParkourLogic:__delete()
  self:Destroy()
end

function GhostParkourLogic:Enter(param)
  self.battleMgr = DataCenter.LWBattleManager
  local qualityLevel = GameQualitySettings.GetQualityByConfigLevel()
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  self.highQualityMode = GameQualitySettings.IsHighGearQuality()
  self.showDeviceLevel = deviceLevel + 1
  self.ignoreSpectacularEffect = deviceLevel < EDeviceLevel.Mid and qualityLevel < 4
  self.lowDevice = deviceLevel < EDeviceLevel.MidLow
  self.ultraLowDevice = deviceLevel < EDeviceLevel.Low
  self.isDecorationMeshOpen = LuaEntry.DataConfig:CheckSwitch("surfing_decoration_instance_test")
  self.isMemoryPoolOpen = LuaEntry.DataConfig:CheckSwitch("surfing_memory_pool_test")
  PveUnitViewUtil.InitView()
  EffectViewUtil.InitView()
  self.isDebug = CS.CommonUtils.IsDebug()
  self.isEditor = CS.UnityEngine.Application.isEditor
  self.editorOpValid = self.isEditor
  self.isPC = Config.IsPC()
  self.pcOpTimer = 0
  self.valid = true
  self.waitingLoad = nil
  self.unitGuid = 0
  self.unitMgr = UnitManager.New(self)
  self:InitMonsterManager()
  self.__event_handlers = {}
  self.param = param
  self.checkValid = false
  self.isGuide = false
  self.lastPause = false
  local lane = 1
  if param then
    self.checkValid = param.enterType ~= PVEEnterType.GM and param.enterType ~= PVEEnterType.Guide
    self.isGuide = param.enterType == PVEEnterType.Guide
    self:InitData(param)
    self.curGuide = 1
    self.guidingType = nil
    self.guidingWaiting = nil
    lane = param.message and param.message.lane or param.lane or 1
  end
  self.curLine = self:GetCurLine(lane)
  self.scenes = {}
  self.speedZ = self.data and self.data:GetMoveSpeed() or 0
  self.endLine = nil
  self.stageIndex = nil
  local pos = self:GetBirthPos(self.curLine)
  self.birthPos = pos
  self.skyBoxX = pos.x
  self.totalRunTime = 0
  self.totalPauseTime = 0
  self.checkTimer = 0
  self.fingerDownTimer = 0
  self.doubleClickTimer = 0
  self.buffNum = 0
  self.nitrogenNum = 0
  self.collisionNum = 0
  self:ChangeState(Const.SurfingState.Ready)
  local id = self.data and self.data.meta and self.data.meta.bgm
  if not string.IsNullOrEmpty(id) then
    self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(tonumber(id), true, true)
  end
  if self.isGuide then
    self.needEnergy = 3
  else
    _, self.needEnergy = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  end
  self.playerCount = 0
  self:AddListeners()
end

function GhostParkourLogic:GetPVEType()
  return PVEType.GhostParkour
end

function GhostParkourLogic:OnUpdate()
  local deltaTime = 0
  if self.isDebug and self.isEditor then
    deltaTime = Time.deltaTime
  else
    deltaTime = Time.unscaledDeltaTime
  end
  self.frames = self.frames + 1
  self.frameTimer = self.frameTimer + deltaTime
  if self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Entrance then
    return
  end
  self:UpdateKeyboard()
  self.totalRunTime = self.totalRunTime + deltaTime
  ProfilerUtil.BeginSample("GhostParkourLogic.OnUpdate.CheckLoadedCount")
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
  ProfilerUtil.BeginSample("GhostParkourLogic.OnUpdate.OnFingerHold")
  if self.fingerDown then
    self:OnFingerHold(deltaTime)
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("GhostParkourLogic.OnUpdate.UpdateScene")
  self:UpdateScene()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("GhostParkourLogic.OnUpdate.PlayerUpdate")
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
  ProfilerUtil.BeginSample("GhostParkourLogic.OnUpdate.MonsterMgrUpdate")
  if self.monsterMgr ~= nil then
    local viewY = self:GetCurDistanceData()
    self.monsterMgr:Update(viewY, deltaTime)
  end
  ProfilerUtil.EndSample()
  self:UpdateSkybox()
  self:UpdateCheck(deltaTime)
  if self.isGuide then
    self:CheckGuide()
  end
end

function GhostParkourLogic:OnUpdateSec()
  self.sampleCd = self.sampleCd - 1
  if self.sampleCd <= 0 then
    self.sampleCd = FPS_SAMPLE_CD
    local fps = (Time.frameCount - self.sampleFrame) / FPS_SAMPLE_CD
    self.sampleFrame = Time.frameCount
    if fps < self.lowestFps then
      self.lowestFps = fps
    end
  end
end

function GhostParkourLogic:Destroy()
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
  self.buffList = nil
  self.energyNum = nil
  self.valid = false
  self.waitingLoad = nil
  self.loadingFinishMark = nil
  self.loadingFlag = nil
  if self.ghostParkourLogger then
    self.ghostParkourLogger:Delete()
    self.ghostParkourLogger = nil
  end
  if self.data then
    self.data:Delete()
    self.data = nil
  end
  self.start = nil
  self.startLoading = nil
end

function GhostParkourLogic:InitMonsterManager()
  local SurfingMonsterManager = require("Scene.LWBattle.Surfing.Monster.SurfingMonsterManager")
  self.monsterMgr = SurfingMonsterManager.New()
end

function GhostParkourLogic:InitData(param)
  if self.isGuide then
    if param then
      local levelId = param.levelId
      self.data = GhostParkourData.New(self, levelId, param)
    end
    return
  end
  local GhostParkourLogger = require("Scene.LWBattle.GhostParkour.GhostParkourLogger")
  self.ghostParkourLogger = GhostParkourLogger.New(PVELogFuncType.GhostParkour)
  if param then
    local levelId = param.levelId
    local gm = param.enterType == PVEEnterType.GM
    self.gm = gm
    self:LogStageId(param.levelId)
    self.data = GhostParkourData.New(self, levelId, param)
  end
end

function GhostParkourLogic:LoadScene(callBack)
  self.loadingFlag = self.loadingFlag + 1
  self:LoadPlayer()
  if self.isDecorationMeshOpen or self.isDebug and GMUtils.GetBool(GMConst.NewPVEDecorationShowMethod, false) then
    self.staticMgr = CS.PVEStaticDecorationManager()
  else
    self.staticMgr = CS.PVEStaticManager()
  end
  self.staticMgr:InitLW(20, 5)
  self.staticMgr:SetVisibleChunk(3)
  self.staticMgr:SetChunkUnloadEnable(true)
  self.staticMgr:SetGrading(self.showDeviceLevel, 30)
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

function GhostParkourLogic:CheckGuide()
  if self.guidingType ~= nil then
    return
  end
  local guideIds = self.data and self.data.guideIds
  if guideIds == nil then
    self:OnGuideFinish()
    return
  end
  local curGuideData = guideIds[self.curGuide]
  if curGuideData == nil then
    self:OnGuideFinish()
    return
  end
  local dis = curGuideData[1]
  local guideType = curGuideData[2]
  if dis == nil or guideType == nil then
    self:OnGuideFinish()
    return
  end
  local curDistance = self:GetCurDistanceData()
  if dis <= curDistance then
    self.guidingType = guideType
    self.fingerDown = false
    if guideType == GuideOpType.Finish then
      self:OnGuideFinish()
      return
    end
    DataCenter.LWBattleManager:SetGamePause(true)
    self.lastPause = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuide, {anim = true}, self.guidingType)
  end
end

function GhostParkourLogic:CheckGuideView(guideOpType)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UISurfingBattleGuide)
  if window == nil then
    return false
  end
  local view = window.View
  if view == nil then
    return false
  end
  local touchInput = self.touchCamera.touchInput
  local curPos = touchInput:GetFingerDownPosition()
  if guideOpType == GuideOpType.DoubleClick then
    local waiting, valid = view:CheckClickGuideView(guideOpType, self.fingerDownPos, self.lastClickPos)
    return waiting, valid
  elseif guideOpType == GuideOpType.Click then
    if self.fingerDown then
      return false
    end
    local waiting, valid = view:CheckClickGuideView(guideOpType, self.fingerDownPos)
    return waiting, valid
  end
  local waiting, valid = view:CheckGuideView(guideOpType, self.fingerDownPos, curPos)
  return waiting, valid
end

function GhostParkourLogic:UpdateGuideOp()
  if not self.guidingType then
    return
  end
  if self.guidingWaiting then
    if self.guidingType == GuideOpType.Up then
      local waiting, valid = self:CheckGuideView(GuideOpType.Up)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveUp()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.Down then
      local waiting, valid = self:CheckGuideView(GuideOpType.Down)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveDown()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.Left then
      local waiting, valid = self:CheckGuideView(GuideOpType.Left)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveLeft()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.Right then
      local waiting, valid = self:CheckGuideView(GuideOpType.Right)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveRight()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.DoubleClick then
      if self.guildDoubleClick then
        local waiting, valid = self:CheckGuideView(GuideOpType.DoubleClick)
        if waiting then
          self.guidingWaiting = nil
          self:OnNitrogenSpeedUp()
          self.guidingType = nil
          self.curGuide = self.curGuide + 1
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
          self:ContinueGame()
          self.lastPause = false
        else
          self.doubleClickCheck = true
        end
        self.guildDoubleClick = false
      end
    elseif self.guidingType == GuideOpType.Click then
      local waiting, valid = self:CheckGuideView(GuideOpType.Click)
      if waiting then
        self.guidingWaiting = nil
        self:OnNitrogenSpeedUp()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.PickEnergyL then
      local waiting, valid = self:CheckGuideView(GuideOpType.PickEnergyL)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveLeft()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    elseif self.guidingType == GuideOpType.PickEnergyR then
      local waiting, valid = self:CheckGuideView(GuideOpType.PickEnergyR)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveRight()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        self:ContinueGame()
        self.lastPause = false
      end
    end
    return
  end
  if not self.fingerDown then
    self.fingerDownPos = nil
  end
  if self.guidingType == GuideOpType.Up then
    local waiting, valid = self:CheckGuideView(GuideOpType.Up)
    if valid then
      self.guidingWaiting = true
    end
  elseif self.guidingType == GuideOpType.Down then
    local waiting, valid = self:CheckGuideView(GuideOpType.Down)
    if valid then
      self.guidingWaiting = true
    end
  elseif self.guidingType == GuideOpType.Left then
    local waiting, valid = self:CheckGuideView(GuideOpType.Left)
    if valid then
      self.guidingWaiting = true
    end
  elseif self.guidingType == GuideOpType.Right then
    local waiting, valid = self:CheckGuideView(GuideOpType.Right)
    if valid then
      self.guidingWaiting = true
    end
  elseif self.guidingType == GuideOpType.DoubleClick then
    self.guidingWaiting = true
    self.doubleClickCheck = true
  elseif self.guidingType == GuideOpType.Click then
    self.guidingWaiting = true
  elseif self.guidingType == GuideOpType.PickEnergyL then
    local waiting, valid = self:CheckGuideView(GuideOpType.PickEnergyL)
    if valid then
      self.guidingWaiting = true
    end
  elseif self.guidingType == GuideOpType.PickEnergyR then
    local waiting, valid = self:CheckGuideView(GuideOpType.PickEnergyR)
    if valid then
      self.guidingWaiting = true
    end
  end
end

function GhostParkourLogic:OnGuideFinish()
  if not self.isGuide then
    return
  end
  DataCenter.LWBattleManager:SetGameOver(true)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
  local rewarded = DataCenter.LWGhostParkourDataManager:IsGuideReward()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuideFinish, {anim = true}, {
    skip = false,
    rewarded = rewarded,
    type = 2
  })
  DataCenter.LWGhostParkourDataManager:ReqGuideReward()
end

function GhostParkourLogic:GetCurLine(lane)
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

function GhostParkourLogic:GetBirthPos(curLine)
  local defaultPos = self.data:GetBirthPos()
  if defaultPos then
    local x = defaultPos.x + curLine * LineOffset
    return Vector3.New(x, defaultPos.y, defaultPos.z)
  end
end

function GhostParkourLogic:UpdateCheck(deltaTime)
  if not self.checkValid or self.endGameMsgWaiting then
    return
  end
  self.checkTimer = self.checkTimer + deltaTime
  if self.checkTimer > CheckInterval then
    DataCenter.LWGhostParkourDataManager:ReqTimeCheck(self:GetUuid(), self:GetCurDistanceData(), self.totalRunTime, self.totalPauseTime, self.energyNum + 23, self.buffList)
    self.checkTimer = self.checkTimer - CheckInterval
  end
end

function GhostParkourLogic:CheckLoadFinish(value)
  value = value or 1
  self.loadingFinishMark = self.loadingFinishMark + value
  if self.loadingFinishMark >= self.loadingFlag then
    self:LoadComplete()
  end
end

function GhostParkourLogic:OnStartWaitLoading()
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

function GhostParkourLogic:OnWaitingUpdate()
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

function GhostParkourLogic:LoadComplete()
  self.initComplete = true
  if self.waitingLoad then
    self.waitingLoad = nil
    self:OnShowPlayerInfo()
  end
end

function GhostParkourLogic:UpdateMonsterMgr(sceneCfg)
  if sceneCfg and not string.IsNullOrEmpty(sceneCfg.farmMonster) then
    self.monsterMgr:ReInit(sceneCfg.farmMonster, sceneCfg.offset, sceneCfg.groupId)
  end
end

function GhostParkourLogic:LoadPlayer()
  if self.birthPos == nil then
    self.birthPos = self:GetBirthPos(self.curLine)
  end
  local pos = self.birthPos
  self.player = GhostParkourPlayerUnit.New()
  self.player:Init(self, pos, self.curLine, DataCenter.HeroTemplateManager:GetTemplate(self.data:GetHeroId()), self.speedChangeTime)
  self.loadingFlag = self.loadingFlag + 1
  self.playerCount = self.playerCount + 1
  self:AddUnit(self.player)
  self:LoadOtherPlayer()
end

function GhostParkourLogic:LoadOtherPlayer()
  local matchList = self.param and self.param.message and self.param.message.matchList
  if not table.IsNullOrEmpty(matchList) then
    local player
    self.ghostPlayers = {}
    for i, v in ipairs(matchList) do
      self.loadingFlag = self.loadingFlag + 2
      self.playerCount = self.playerCount + 1
      player = GhostParkourPBPlayerUnit.New()
      local error = player:Init(self, v, self.data:GetHeroId(), self.speedChangeTime, i)
      if error then
        v.markFlag = 1
      else
        self:AddUnit(player)
        if self.ghostPlayers then
          table.insert(self.ghostPlayers, player)
        end
      end
    end
  end
end

function GhostParkourLogic:AddListeners()
  self:AddListener(EventId.GhostParkourOnStageEndCheck, self.OnStageEndCheck)
  self:AddListener(EventId.GhostParkourOnBattleFinished, self.OnGameBattleFinished)
  self:AddListener(EventId.GhostParkourOnBattleStop, self.OnGameStageStop)
  self:AddListener(EventId.Guide_video_Play, self.OnLoadSceneFinished)
  self:AddListener(EventId.GhostParkourOnFileUploadSynced, self.OnUploadFileSynced)
  self:AddListener(EventId.OpenUI, self.OnOpenUIAction)
  self:AddListener(EventId.CloseUI, self.OnCloseUIAction)
  self:AddListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
end

function GhostParkourLogic:RemoveListeners()
  self:RemoveListener(EventId.GhostParkourOnStageEndCheck)
  self:RemoveListener(EventId.GhostParkourOnBattleFinished)
  self:RemoveListener(EventId.GhostParkourOnBattleStop)
  self:RemoveListener(EventId.Guide_video_Play)
  self:RemoveListener(EventId.GhostParkourOnFileUploadSynced)
  self:RemoveListener(EventId.OpenUI)
  self:RemoveListener(EventId.CloseUI)
  self:RemoveListener(EventId.APP_APPLICATION_PAUSE)
end

function GhostParkourLogic:OnShowPlayerInfo()
  if self.isGuide then
    self:OnStart()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.param and self.param.message)
    self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIGhostParkourBattleMain).View
    return
  end
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
    start = true
  })
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.param and self.param.message)
  self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIGhostParkourBattleMain).View
  self:ChangeState(Const.SurfingState.Entrance)
end

function GhostParkourLogic:OnStart()
  self.start = true
  self:RemoveSceneUpdator()
  if self.mainUI then
    self.mainUI:OnStart()
  end
  self:ChangeState(Const.SurfingState.Surfing)
  DataCenter.LWSoundManager:PlaySound(11004, false)
  self.battleMgr:SetGameStart(true)
end

function GhostParkourLogic:ChangeState(newState)
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
    if self.gm then
      Logger.LogError("totalRuntime = " .. self.totalRunTime .. ", " .. DataCenter.LWGhostParkourDataManager:GetTimeFormat(self.totalRunTime * 1000))
    end
    self.state = newState
    self.player:ChangeToFinish()
    if self.mainUI then
      self.mainUI:OnNitrogenSpeedUpFinished()
    end
    if self.ghostPlayers then
      for _, v in pairs(self.ghostPlayers) do
        if v then
          v:ChangeToFinish()
        end
      end
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

function GhostParkourLogic:CloseWindows()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingGuild) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingGuild)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleMain) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleMain)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleCountDown) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleCountDown)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuideFinish)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourWaitLoading)
end

function GhostParkourLogic:GetOffsetZ(height, rotation)
  return height / math_tan(rotation * math_pi / 180)
end

function GhostParkourLogic:AddLateUpdate()
  if self.lateUpdateTimer == nil then
    function self.lateUpdateTimer()
      self:OnLateUpdate()
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateTimer)
  end
end

function GhostParkourLogic:RemoveLateUpdate()
  if self.lateUpdateTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateTimer)
    self.lateUpdateTimer = nil
  end
end

function GhostParkourLogic:OnLateUpdate()
  if not self.battleMgr:IsPlayingShakeCamera() then
    local deltaTime = 0
    if self.isDebug and self.isEditor then
      deltaTime = Time.deltaTime
    else
      deltaTime = Time.unscaledDeltaTime
    end
    self:UpdateCameraFollow(deltaTime)
  end
  if self:CheckUpdateDecoration() and self.touchCamera and self.staticMgr then
    CS.CSUtils.UpdatePVEStaticMgrWithRealPos(self.touchCamera, self.staticMgr, 30, self.renderOffsetZ)
  end
end

function GhostParkourLogic:CheckUpdateDecoration()
  if self.isDecorationMeshOpen then
    return not self.ultraLowDevice
  end
  return not self.lowDevice
end

function GhostParkourLogic:EndGame()
  self:LogDeadline(EXIT_FLAGS.WIN)
  DataCenter.LWBattleManager:SetGameOver(true)
  if self.curScene then
    local actualIndex = self.curScene:GetActualIndex()
    local id = self.curScene:GetId()
    local addCoin = self.energyNum or -23
    local currentInt = self:GetCurDistanceData()
    if self.mainUI then
      self.mainUI:SyncTime(self.totalRunTime * 1000)
    end
    self.endGameMsgWaiting = DataCenter.LWGhostParkourDataManager:ReqEndGame(self:GetUuid(), actualIndex, id, currentInt, addCoin + 26, self.totalRunTime, self.buffList)
  end
end

function GhostParkourLogic:EndStage(groupIndex)
  if self.endGameMsgWaiting then
    return
  end
  if self.curScene then
    local actualIndex = self.curScene:GetActualIndex()
    local endZ = self.data and self.data:GetCurStageSceneLen(groupIndex) or 0
    local id = self.curScene:GetId()
    local addCoin = self.energyNum or -23
    DataCenter.LWGhostParkourDataManager:ReqEndStage(self:GetUuid(), actualIndex, id, endZ, addCoin + 26, self.recordPlayers)
  end
end

function GhostParkourLogic:OnBeKickedFromGame(tipsId)
  tipsId = tipsId or "parkour_cheat_01"
  DataCenter.LWBattleManager:SetGameOver(true)
  self:ExitSurfing()
  DataCenter.LWBattleManager:ShowTipsId(tipsId)
  if self.battleMgr then
    self.battleMgr:Exit(nil, "lose")
  end
end

function GhostParkourLogic:GetSwitchMonsterId()
  return self.data:GetSwitchMonsterId()
end

function GhostParkourLogic:CheckOffsetZ(newZ)
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

function GhostParkourLogic:ApplyResetOffsetZ()
  local cameraTransform = self.touchCamera.transform
  if IsNotNull(cameraTransform) then
    local x, y, z = cameraTransform:Get_position()
    cameraTransform:Set_position(x, y, z - RenderOffsetInterval)
  end
  PvePhysicsUtil.ResetPlayerColliderData()
  self.monsterMgr:ResetRenderPosition()
  if self.scenes then
    for _, scene in ipairs(self.scenes) do
      if scene then
        scene:ResetRenderPosition()
      end
    end
  end
  if self.staticMgr then
    self.staticMgr:SetRenderOffsetZ(self.renderOffsetZ)
  end
end

function GhostParkourLogic:OnUpdatePause()
  local deltaTime = Time.unscaledDeltaTime
  self.totalPauseTime = self.totalPauseTime + deltaTime
  if self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Entrance then
    return
  end
  self:UpdateCheck(deltaTime)
  if self.isGuide then
    self:UpdateGuideOp()
  end
end

function GhostParkourLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function GhostParkourLogic:RemoveUnit(guid)
  if self.isMemoryPoolOpen then
    self.unitMgr:RemoveUnitTotalById(guid)
  else
    self.unitMgr:RemoveUnitById(guid)
  end
end

function GhostParkourLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function GhostParkourLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function GhostParkourLogic:GetMoveSpeed()
  return self.speedZ
end

function GhostParkourLogic:GetSpeedBoardParam()
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

function GhostParkourLogic:DealDamage(attacker, defender, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, exValue)
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

function GhostParkourLogic:GetCurDistanceData()
  local z = self.player and self.player:GetPosition().z or 0
  return z - self.renderOffsetZ
end

function GhostParkourLogic:GetCurPos()
  return self.player and self.player:GetPosition()
end

function GhostParkourLogic:GetPlayersPosition()
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

function GhostParkourLogic:GetCurTotalRunTime()
  return self.totalRunTime
end

function GhostParkourLogic:GetMonster(guid)
  return self.monsterMgr:GetMonster(guid)
end

function GhostParkourLogic:GetUuid()
  return self.param and self.param.uuid
end

function GhostParkourLogic:RecordGoods(type, goodsId, goodsCount)
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

function GhostParkourLogic:RecordBuffList(buffType, buffId, bornId, monsterId)
  if not self.checkValid or self.endGameMsgWaiting then
    return
  end
  local distance = self:GetCurDistanceData()
  local buffStr = buffType .. ";" .. buffId .. ";" .. distance .. ";" .. monsterId .. ";" .. bornId
  table.insert(self.buffList, buffStr)
  if buffType == ParkourBuffType.SPEED_BOARD then
    self.buffNum = self.buffNum + 1
  elseif buffType == ParkourBuffType.NITROGEN then
    self.nitrogenNum = self.nitrogenNum + 1
  elseif buffType == ParkourBuffType.OBSTACLE then
    self.collisionNum = self.collisionNum + 1
  end
end

function GhostParkourLogic:GetScoreMultiplier()
  return 1
end

function GhostParkourLogic:AppendLog()
end

function GhostParkourLogic:OnNitrogenSpeedUp()
  if self.curEnergy < self.needEnergy then
    return
  end
  self.curEnergy = 0
  if self.player then
    local buffId = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
    local buff = self.player:AddBuff(buffId)
    EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {buff = buff})
    self:OnBuffAdd(buff)
    self.player:ShowUnitEffect(SurfingUnitEffectType.GotProps)
  end
  if self.mainUI then
    self.mainUI:RefreshEnergy()
  end
  self:RecordBuffList(ParkourBuffType.NITROGEN, self:GetNitrogenBuffId(), 0, 0)
end

function GhostParkourLogic:GetNitrogenNeedEnergy()
  return self.needEnergy
end

function GhostParkourLogic:HideGhostPlayer(index)
  if index and self.param and self.param.message and self.param.message.matchList then
    local matchList = self.param.message.matchList
    local data = matchList[index]
    if data then
      data.markFlag = 1
      if self.ghostPlayers then
        local player = self.ghostPlayers[index]
        if player then
          player:HideGhostPlayer()
          self.ghostPlayers[index] = nil
          self.playerCount = self.playerCount - 1
        end
      end
      if table.IsNullOrEmpty(self.ghostPlayers) then
        self.ghostPlayers = nil
      end
    end
  end
end

function GhostParkourLogic:GetNitrogenBuffSpeed()
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

function GhostParkourLogic:GetNitrogenBuffId()
  if self.nitrogenBuffId == nil then
    self.nitrogenBuffId, self.nitrogenActiveNum = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  end
  return self.nitrogenBuffId
end

function GhostParkourLogic:GetNitrogenActiveNum()
  if self.nitrogenActiveNum == nil then
    self.nitrogenBuffId, self.nitrogenActiveNum = DataCenter.LWGhostParkourDataManager:GetNitrogenBuffId()
  end
  return self.nitrogenActiveNum
end

function GhostParkourLogic:GetCurSpeed()
  return self.player and self.player:GetMoveSpeed() or self:GetMoveSpeed()
end

function GhostParkourLogic:GetMaxMeters()
  return self.data and self.data:GetMaxMeters() or 0
end

function GhostParkourLogic:OnNitrogenSpeedUpFinished()
  if self.mainUI then
    self.mainUI:OnNitrogenSpeedUpFinished()
  end
end

function GhostParkourLogic:OnAnimFinished()
  self.showEndPanel = true
  EventManager:GetInstance():Broadcast(EventId.GhostParkourOnEndAnimFinished)
end

function GhostParkourLogic:GetRankOffsetZ()
  if self.playerCount and self.playerCount > 0 then
    self.playerCount = self.playerCount - 1
    return 4 * self.playerCount
  end
  return 0
end

function GhostParkourLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function GhostParkourLogic:RemoveListener(msg_name)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function GhostParkourLogic:LoadSkybox()
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

function GhostParkourLogic:UpdateSkybox()
  if self.skyboxValid and self.player then
    local pos = self.player:GetPosition()
    self.skyboxTrans:Set_localPosition(self.skyBoxX, 0, pos.z)
  end
end

function GhostParkourLogic:LoadSceneExt()
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

function GhostParkourLogic:PreloadUnit()
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_ditiepaoku_speed_buff_1.prefab", 20)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_ditiepaoku_speed_buff_2.prefab", 20)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Buff/O_env_paoku_01_g.prefab", 50)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/GhostParkour/Hero/A_Hero_surfing_paoku01_hong_ghost.prefab", 1)
end

function GhostParkourLogic:PreloadEffect()
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

function GhostParkourLogic:LoadSceneComplete()
  if self.birthPos == nil then
    self.birthPos = self:GetBirthPos(self.curLine)
  end
  local pos = self.birthPos
  self.battleMgr:LookAt(pos)
  self:FixCameraFar()
  self:AddSceneUpdator()
  self:AddLateUpdate()
end

function GhostParkourLogic:LoadSceneByCount(count, callBack)
  if not self.data then
    Logger.LogInfo("GhostParkour -- the logic data is nil")
    self:OnBeKickedFromGame()
    return
  end
  ProfilerUtil.BeginSample("GhostParkourLogic.LoadSceneByCount")
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

function GhostParkourLogic:CheckSceneData()
  return false
end

function GhostParkourLogic:GetLastSceneData()
  if self.scenes then
    local scene = self.scenes[#self.scenes]
    if scene then
      return scene.sceneData
    end
  end
  return nil
end

local function CheckEndStage(self, curScene)
  if self.gm or self.isGuide then
    return
  end
  if self.curScene == nil or curScene == nil then
    Logger.LogInfo("GhostParkour -- [CheckEndStage] self.curScene is nil")
    return
  end
  if curScene == nil then
    Logger.LogInfo("GhostParkour -- [CheckEndStage] curScene is nil")
    return
  end
  local oldIndex = self.curScene:GetActualIndex()
  local newIndex = curScene:GetActualIndex()
  if oldIndex ~= newIndex and self.stageIndex ~= oldIndex and 0 < oldIndex then
    self:EndStage(oldIndex)
    self.stageIndex = oldIndex
  end
end

function GhostParkourLogic:UpdateScene()
  if self.scenes and self.data then
    local followZ = self:GetCurDistanceData()
    if self.curScene ~= nil and self.curScene:IsContainsZ(followZ) then
      if self.endLine ~= nil and followZ >= self.endLine then
        self:ChangeState(Const.SurfingState.Win)
      end
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
    ProfilerUtil.BeginSample("GhostParkourLogic.UpdateScene.CheckEndStage")
    CheckEndStage(self, curScene)
    ProfilerUtil.EndSample()
    self.curScene = curScene
    if curScene == nil then
      local logStr = "GhostParkour -- " .. self:GetCurDistanceData() .. "\n"
      if table.IsNullOrEmpty(self.scenes) then
        logStr = logStr .. "the scenes is nil"
      else
        for i, v in ipairs(self.scenes) do
          if v == nil then
            logStr = logStr .. "index = " .. i .. ", value = nil \n"
          else
            local config = v.sceneData and v.sceneData.config
            if config == nil then
              logStr = logStr .. "index = " .. i .. ", sceneData or config is nil \n"
            else
              logStr = logStr .. string.format("index = %s sceneStageId = %s sceneId = %s startZ = %s endZ = %s\n", config:GetActualIndex(), config:GetId(), config:GetSceneId(), v:GetStartZ(), v:GetEndZ())
            end
          end
        end
      end
      Logger.LogInfo(logStr)
      DataCenter.LWBattleManager:ShowTipsId("parkour_cheat_01")
      DataCenter.LWBattleManager:Exit()
    end
  end
end

function GhostParkourLogic:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function GhostParkourLogic:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function GhostParkourLogic:SceneUpdate()
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

function GhostParkourLogic:OnStageEndCheck(uuid)
  if uuid == nil or uuid ~= self:GetUuid() then
    Logger.LogError("GhostParkour -- [OnStageEndCheck] uuid is nil or unequally")
    self:OnBeKickedFromGame()
  end
end

function GhostParkourLogic:OnGameStageStop(t)
  if t and t.uuid == self:GetUuid() then
    Logger.LogError("GhostParkour -- [OnGameStageStop] be kicked")
    self:OnBeKickedFromGame()
  end
end

function GhostParkourLogic:OnGameBattleFinished(t)
  self.endGameMsgWaiting = false
  if t == nil then
    Logger.LogError("GhostParkour -- [OnGameBattleFinished] end game message info is nil")
    if self.battleMgr then
      self:ExitSurfing()
      self.battleMgr:Exit(nil, "lose")
    end
    return
  end
  self:Track(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
    if self.battleMgr then
      self:ExitSurfing()
      self.battleMgr:Exit(nil, "lose")
    end
    return
  end
  if t.uuid ~= self:GetUuid() then
    Logger.LogError("GhostParkour -- [OnGameBattleFinished] message uuid is not equality self.uuid")
    if self.battleMgr then
      self:ExitSurfing()
      self.battleMgr:Exit(nil, "lose")
    end
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuideFinish)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
  local fightType = t.fightType
  if fightType == 1 then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleResult) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourBattleResult)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleResult, {anim = true}, t)
  elseif fightType == 2 then
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourChallengeResult) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourChallengeResult)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourChallengeResult, {anim = true}, t)
  end
end

function GhostParkourLogic:OnLoadSceneFinished()
  CS.SceneManager.SetRollStrengthZ(0.6)
  CS.SceneManager.SetRollStrengthX(0, -18, 0.8)
  self:FixCameraFar()
end

function GhostParkourLogic:OnBuffAdd(buff)
  if self.player then
    self.player:OnBuffAdd(buff)
  end
end

function GhostParkourLogic:OnUploadFileSynced()
  if self.ghostParkourLogger then
    self.ghostParkourLogger:DeleteLog()
  end
end

function GhostParkourLogic:OnOpenUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      return
    end
    self:Pause(true)
  end
end

function GhostParkourLogic:OnCloseUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    if self.isGuide and self.lastPause then
      return
    end
    if self.endGameMsgWaiting then
      self:EndGame()
    end
  end
end

function GhostParkourLogic:OnApplicationPause(isPaused)
  if isPaused then
    self:Pause(true)
  else
    if self.isGuide and self.lastPause then
      return
    end
    if self.endGameMsgWaiting then
      self:EndGame()
    end
  end
end

function GhostParkourLogic:Pause(pause)
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
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourPause) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleResult) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourChallengeResult) or self.endGameMsgWaiting then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourPause, {anim = true})
  else
    if self.isGuide and self.lastPause then
      return
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGhostParkourBattleCountDown) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourBattleCountDown, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, {isPlayback = false, start = false})
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GhostParkourOnBattlePaused, pause)
end

function GhostParkourLogic:WaitingPause(pause)
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

function GhostParkourLogic:ContinueGame()
  self.battleMgr:SetGamePause(false)
  self:ChangeState(Const.SurfingState.Surfing)
  if not self.start then
    self:OnStart()
  end
end

function GhostParkourLogic:Track(t)
  if t then
    local uuid = t.uuid or 0
    local distance = t.distance or 0
    local coin = t.coin or 0
    local buffNum = self.buffNum or 0
    local stageId = t.stageId or 0
    local id = t.id or 0
    local nitrogenNum = self.nitrogenNum or 0
    local collisionNum = self.collisionNum or 0
    local totalRunTime = t.totalRunTime or 0
    local avgFPS = self:GetAvgFPS()
    local lowestFPS = self:GetLowestFPS()
    local highestFps = CS.UnityEngine.Application.targetFrameRate
    local posX = self.player and self.player:GetPosition().x or 0
    local posZ = self:GetCurDistanceData()
    PostEventLog.Track(PostEventLog.Defines.GHOST_GAMING_ON_END, {
      uuid = tostring(uuid),
      stageCostTime = totalRunTime,
      finalvalue = distance,
      int_para1 = coin,
      picking_score = buffNum,
      int_para2 = nitrogenNum,
      atk_num = collisionNum,
      stageId = stageId,
      id = id,
      fps = avgFPS,
      minFps = lowestFPS,
      pcurfps = highestFps,
      tar_x = posX,
      tar_y = posZ
    })
  end
end

function GhostParkourLogic:GetAvgFPS()
  if self.frameTimer == 0 then
    return -1
  end
  return self.frames / self.frameTimer
end

function GhostParkourLogic:GetLowestFPS()
  return math.min(self.lowestFps, self:GetAvgFPS())
end

function GhostParkourLogic:ShowEffectObj(path, pos, rot, time, parent, type)
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

function GhostParkourLogic:ShowEffectParent(id, parent)
  if not id then
    return
  end
  EffectViewUtil.ShowEffectParent(id, parent)
end

function GhostParkourLogic:ResetEffectPosition(id, x, y, z)
  if not id then
    return
  end
  EffectViewUtil.ResetPosition(id, x, y, z)
end

function GhostParkourLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function GhostParkourLogic:DoVibration(intensity, sharpness, duration)
  if self.highQualityMode and self.totalRunTime - self.vibrationTimer > self.vibrationDuration then
    self.battleMgr:DoVibration(intensity, sharpness, duration)
    self.vibrationTimer = self.totalRunTime
  end
end

function GhostParkourLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
  self:InitTouchInput()
end

function GhostParkourLogic:InitTouchInput()
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

function GhostParkourLogic:FixCameraFar()
  self.camera = self.battleMgr.camera
  if self.camera then
    self.camera.farClipPlane = 200
  end
end

function GhostParkourLogic:UnInitCamera()
  self:UnInitTouchInput()
end

function GhostParkourLogic:UnInitTouchInput()
  if self.touchCamera and self.touchCamera.touchInput then
    local touchInput = self.touchCamera.touchInput
    self.touchCamera.CanMoveing = true
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
  end
end

function GhostParkourLogic:InitCameraParams()
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

function GhostParkourLogic:GetCameraParam()
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

function GhostParkourLogic:UpdateCameraFollow(deltaTime)
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

function GhostParkourLogic:OnFingerDown(pos)
  if self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Entrance then
    return
  end
  if not self.battleMgr.gameStart or self.battleMgr.gameOver then
    return
  end
  if self.battleMgr.gamePause and not self.isGuide then
    return
  end
  self.fingerDown = true
  self.fingerDownPos = pos
  self.isNotClick = false
  if self.isGuide then
    self.fingerDownTimer = self.totalPauseTime
  else
    self.fingerDownTimer = self.totalRunTime
  end
end

function GhostParkourLogic:OnFingerUp()
  self.fingerDown = false
  if self.battleMgr.gamePause and not self.isGuide then
    return
  end
  if self.isGuide then
    if self.doubleClickCheck then
      local timer = self.totalPauseTime
      if timer - self.fingerDownTimer < 0.3 then
        if timer - self.doubleClickTimer < 0.5 then
          self.guildDoubleClick = true
          self.doubleClickCheck = false
          self.doubleClickTimer = 0
        else
          self.lastClickPos = self.fingerDownPos
        end
        self.fingerDownTimer = 0
        self.doubleClickTimer = timer
      end
    end
  else
    if self.isNotClick then
      self.isNotClick = nil
      return
    end
    local timer = self.totalRunTime
    if timer - self.fingerDownTimer < 0.3 then
      if timer - self.doubleClickTimer < 0.5 then
        self:OnNitrogenSpeedUp()
        self.doubleClickTimer = 0
      end
      self.fingerDownTimer = 0
      self.doubleClickTimer = timer
    end
  end
end

function GhostParkourLogic:CheckInputDir()
  if self.fingerDown then
    local touchInput = self.touchCamera.touchInput
    local curPos = touchInput:GetFingerDownPosition()
    local hor = curPos.x - self.fingerDownPos.x
    local ver = curPos.y - self.fingerDownPos.y
    local absHor = Mathf.Abs(hor)
    local absVer = Mathf.Abs(ver)
    if absHor <= TouchThreshold and absVer <= TouchThreshold then
      return
    end
    self.fingerDown = false
    if absHor > absVer then
      if 0 < hor then
        self.isNotClick = true
        self:OnMoveRight()
      else
        self.isNotClick = true
        self:OnMoveLeft()
      end
    elseif 0 < ver then
      self.isNotClick = true
      self:OnMoveUp()
    else
      self.isNotClick = true
      self:OnMoveDown()
    end
  end
end

function GhostParkourLogic:OnMoveLeft()
  if self.player then
    return self.player:OnMoveLeft()
  end
end

function GhostParkourLogic:OnMoveRight()
  if self.player then
    return self.player:OnMoveRight()
  end
end

function GhostParkourLogic:OnMoveUp()
  if self.player then
    return self.player:OnMoveUp()
  end
end

function GhostParkourLogic:OnMoveDown()
  if self.player then
    return self.player:OnMoveDown()
  end
end

function GhostParkourLogic:OnFingerHold(deltaTime)
  if self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Entrance then
    return
  end
  if self.isGuide then
    return
  end
  self:CheckInputDir()
end

function GhostParkourLogic:KeyboardOpCheck()
  if self.isGuide then
    return
  end
  if self.pcOpTimer > 0 then
    self.pcOpTimer = self.pcOpTimer - 1
  else
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.UpArrow) and self:OnMoveUp() then
      self.pcOpTimer = PC_OP_Interval
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.DownArrow) and self:OnMoveDown() then
      self.pcOpTimer = PC_OP_Interval
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.LeftArrow) and self:OnMoveLeft() then
      self.pcOpTimer = PC_OP_Interval
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.RightArrow) and self:OnMoveRight() then
      self.pcOpTimer = PC_OP_Interval
    end
  end
end

function GhostParkourLogic:UpdateKeyboard()
  if self.isDebug and self.isEditor then
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.I) then
      local invincible = not self.player.invincible
      self:SetInvincible(invincible)
      EventManager:GetInstance():Broadcast(EventId.SurfingOnGmInvincibleChanged, invincible)
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Space) then
      self:OnNitrogenSpeedUp()
    end
    if self.editorOpValid then
      self:KeyboardOpCheck()
    else
      self.editorOpValid = true
    end
  elseif self.isPC then
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Space) then
      self:OnNitrogenSpeedUp()
    end
    self:KeyboardOpCheck()
  end
end

function GhostParkourLogic:SetInvincible(isOn)
  self.player:SetInvincible(isOn)
end

function GhostParkourLogic:SetOldOption(isOn)
  self.oldOption = isOn
  self.player.oldOption = isOn
end

function GhostParkourLogic:SetJumpVo(value)
  self.player.jumpVoValue = value
end

function GhostParkourLogic:SetGravity(value)
  self.player.gravityValue = value
end

function GhostParkourLogic:SetHeightLimit(value)
  self.player.heightLimitValue = value
end

function GhostParkourLogic:SetJumpDuration(value)
  self.player.jumpDurationValue = value
end

function GhostParkourLogic:SetCurveTopParam(value)
  self.player.curveTopParamValue = value
end

function GhostParkourLogic:GetOldOption()
  return self.player.oldOption
end

function GhostParkourLogic:GetJumpVo()
  return self.player.jumpVoValue
end

function GhostParkourLogic:GetGravity()
  return self.player.gravityValue
end

function GhostParkourLogic:GetHeightLimit()
  return self.player.heightLimitValue
end

function GhostParkourLogic:GetJumpDuration()
  return self.player.jumpDurationValue
end

function GhostParkourLogic:GetCurveTopParam()
  return self.player.curveTopParamValue
end

function GhostParkourLogic:ExitSurfing()
  if self.isGuide then
    return
  end
  if self.isEditor or self.isDebug then
    local logStr = ""
    if self.player then
      logStr = self.player:GetSpeedStr()
    end
    self.ghostParkourLogger:SaveOutputLog(self:GetUuid(), logStr)
  else
    self:ExitDelFile()
  end
end

function GhostParkourLogic:LogStageId(levelId)
  if self.ghostParkourLogger then
    self.ghostParkourLogger:LogStageId(levelId, self:GetUuid(), UITimeManager:GetInstance():GetServerSeconds())
  end
end

function GhostParkourLogic:LogPlayerInput(input)
  if self.ghostParkourLogger then
    self.ghostParkourLogger:LogInput(input, self.totalRunTime, self.frames)
  end
end

function GhostParkourLogic:LogDeadline(flag)
  if self.ghostParkourLogger then
    self.ghostParkourLogger:LogDeadline(flag, self.endLine or self:GetCurDistanceData(), self.totalRunTime)
  end
end

function GhostParkourLogic:LogEvent(flag, speed, totalRunTime)
  if self.ghostParkourLogger then
    self.ghostParkourLogger:LogEvent(flag, speed or 0, totalRunTime)
  end
end

function GhostParkourLogic:SaveLog(callback)
  if self.ghostParkourLogger then
    ProfilerUtil.BeginSample("GhostParkourLogic:SaveLog")
    local logStr = ""
    if self.player then
      logStr = self.player:GetSpeedStr()
    end
    self.ghostParkourLogger:SaveAll(self:GetUuid(), callback, logStr, DataCenter.LWGhostParkourDataManager:GetBeginTime())
    ProfilerUtil.EndSample()
  end
end

function GhostParkourLogic:ExitDelFile()
  if self.ghostParkourLogger then
    self.ghostParkourLogger:Exit()
  end
end

return GhostParkourLogic
