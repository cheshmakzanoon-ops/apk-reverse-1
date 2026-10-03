local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local SurfingLogic = BaseClass("SurfingLogic", base)
local SurfingData = require("DataCenter.LWBattle.Logic.Surfing.SurfingData")
local SurfingScene = require("DataCenter.LWBattle.Logic.Surfing.SurfingScene")
local SurfingPlayerUnit = require("Scene.LWBattle.Surfing.SurfingPlayerUnit")
local Const = require("Scene.LWBattle.Const")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")
local SurfingSceneData = require("DataCenter.LWBattle.Logic.Surfing.SurfingSceneData")
local math_tan = math.tan
local math_pi = math.pi
local defaultFov = 40
local defaultHeight = 8.5
local defaultRotation = 16
local TouchThreshold = 20
local ClearMonsterOffset = 120
local CheckInterval = 5
local SPEED_CHANGE_TIME = 1
local RenderOffsetInterval = 64000
local FPS_SAMPLE_CD = 10
local LOADING_FINISH_FLAG = 2
local PC_OP_Interval = 4
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local SkyboxPath = "Assets/Main/Prefabs/BountyHunter/Scene/LastWar_Scene_skybox_pk.prefab"
local GuideOpType = {
  Up = 1,
  Down = 2,
  Left = 3,
  Right = 4,
  Finish = 5
}

function SurfingLogic:__init()
  if DataCenter.LWBattleManager.lineOffset then
    TouchThreshold = DataCenter.LWBattleManager.touchThreshold
  end
  self.goods = {}
  self.staticEffectCommonPos = Vector3.zero
  self.speedChangeTime = SPEED_CHANGE_TIME
  self.renderOffsetZ = 0
  self.frames = 0
  self.frameTimer = 0
  self.sampleCd = FPS_SAMPLE_CD
  self.sampleFrame = Time.frameCount
  self.lowestFps = 999
  self.loadingFinishMark = 0
  self.lastMoveTime = 0
  self.moveIndex = 0
  self.playbackSW = DataCenter.LWSurfingDataManager:GetPlaybackSwitchOn()
end

function SurfingLogic:__delete()
  self:Destroy()
end

function SurfingLogic:Enter(param)
  self.battleMgr = DataCenter.LWBattleManager
  local qualityLevel = GameQualitySettings.GetQualityByConfigLevel()
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  deviceLevel = Mathf.Clamp(deviceLevel, EDeviceLevel.UltraLow, EDeviceLevel.UltraHigh)
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
  if param then
    self:InitData(param)
    self.checkValid = param.enterType ~= PVEEnterType.GM and param.enterType ~= PVEEnterType.Guide
    self.isGuide = param.enterType == PVEEnterType.Guide
    self.curGuide = 1
    self.guidingType = nil
    self.guidingWaiting = nil
  end
  self:InitInviteAllyData(param)
  self.recordPlayers = nil
  self.sceneCount = 0
  self.scenes = {}
  self.loopBorn = true
  self.speedZ = 0
  self.endLine = nil
  self.infiniteZ = nil
  self.stageIndex = nil
  local pos = self.data:GetBirthPos()
  self.skyBoxX = pos.x
  self.totalRunTime = 0
  self.totalPauseTime = 0
  self.checkTimer = 0
  self.showBoxRemain = nil
  self:ChangeState(Const.SurfingState.Ready)
  local id = self.data and self.data.meta and self.data.meta.bgm
  if not string.IsNullOrEmpty(id) then
    self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(tonumber(id), true, true)
  end
  self:AddListeners()
end

function SurfingLogic:GetPVEType()
  return PVEType.Surfing
end

function SurfingLogic:InitMonsterManager()
  local SurfingMonsterManager = require("Scene.LWBattle.Surfing.Monster.SurfingMonsterManager")
  self.monsterMgr = SurfingMonsterManager.New()
end

function SurfingLogic:InitData(param)
  if self.playbackSW then
    local SurfingLogger = require("Scene.LWBattle.Surfing.SurfingLogger")
    self.surfingLogger = SurfingLogger.New(PVELogFuncType.Surfing, self.isEditor, self.isDebug)
  end
  self.resurgenceTimes = 0
  self.resurgenceLimit = nil
  if param then
    local levelId = param.levelId
    local ids = param.ids
    local gm = param.enterType == PVEEnterType.GM
    self.gm = gm
    self:LogStageId(param.levelId)
    self.data = SurfingData.New(self, levelId, ids, param, self.speedChangeTime)
  end
end

function SurfingLogic:LoadScene(callBack)
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
        self:OnStart()
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
  CS.SceneManager.SetRollStrengthZ(0.6)
  CS.SceneManager.SetRollStrengthX(0, -18, 0.8)
end

function SurfingLogic:LoadPlayer()
  local pos = self.data:GetBirthPos()
  self.player = SurfingPlayerUnit.New()
  self.player:Init(self, pos, 0, DataCenter.HeroTemplateManager:GetTemplate(self.data:GetHeroId()), self.speedChangeTime)
  self:AddUnit(self.player)
end

function SurfingLogic:KeyboardOpCheck()
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

function SurfingLogic:OnUpdate()
  local deltaTime = 0
  if self.isDebug and self.isEditor then
    deltaTime = Time.deltaTime
  else
    deltaTime = Time.unscaledDeltaTime
  end
  self.frames = self.frames + 1
  self.frameTimer = self.frameTimer + deltaTime
  if self.state == Const.SurfingState.Ready then
    return
  end
  self:UpdateKeyboard()
  self.totalRunTime = self.totalRunTime + deltaTime
  ProfilerUtil.BeginSample("SurfingLogic.OnUpdate.CheckLoadedCount")
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
  ProfilerUtil.BeginSample("SurfingLogic.OnUpdate.OnFingerHold")
  if self.fingerDown then
    self:OnFingerHold(deltaTime)
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("SurfingLogic.OnUpdate.UpdateScene")
  self:UpdateScene()
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("SurfingLogic.OnUpdate.PlayerUpdate")
  if self.player then
    self.player:OnUpdate(deltaTime, self.totalRunTime)
  end
  ProfilerUtil.EndSample()
  EffectViewUtil.Update(deltaTime)
  ProfilerUtil.BeginSample("SurfingLogic.OnUpdate.MonsterMgrUpdate")
  if self.monsterMgr ~= nil then
    local viewY = self:GetCurDistanceData()
    self.monsterMgr:Update(viewY, deltaTime)
  end
  ProfilerUtil.EndSample()
  self:UpdateSkybox()
  self:UpdateCheck(deltaTime)
  if self.player then
    self.player:TryApplyCacheCommand()
  end
  if self.isGuide then
    self:CheckGuide()
  end
  if self.playbackSW and self.surfingLogger then
    self.surfingLogger:OnUpdate()
  end
end

function SurfingLogic:AutoMove()
  local offset = self.totalRunTime - self.lastMoveTime
  if 1 <= offset then
    self.lastMoveTime = self.totalRunTime
    self.moveIndex = self.moveIndex + 1
    self.moveIndex = self.moveIndex % 5
    if self.moveIndex == 1 then
      self:OnMoveLeft()
    elseif self.moveIndex == 2 then
      self:OnMoveRight()
    elseif self.moveIndex == 3 then
      self:OnMoveUp()
    elseif self.moveIndex == 4 then
      self:OnMoveDown()
    end
  end
end

function SurfingLogic:UpdateKeyboard()
  if self.isDebug and self.isEditor then
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.I) then
      local invincible = not self.player.invincible
      self:SetInvincible(invincible)
      EventManager:GetInstance():Broadcast(EventId.SurfingOnGmInvincibleChanged, invincible)
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Space) then
      self:PauseGame()
    end
    if self.editorOpValid then
      self:KeyboardOpCheck()
    else
      self.editorOpValid = true
    end
  elseif self.isPC then
    self:KeyboardOpCheck()
  end
end

function SurfingLogic:OnUpdateSec()
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

function SurfingLogic:CheckGuide()
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
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuide, {anim = true}, self.guidingType)
  end
end

function SurfingLogic:CheckGuideView(guideOpType)
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
  local waiting, valid = view:CheckGuideView(guideOpType, self.fingerDownPos, curPos)
  return waiting, valid
end

function SurfingLogic:UpdateGuideOp()
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
        DataCenter.LWBattleManager:SetGamePause(false)
      end
    elseif self.guidingType == GuideOpType.Down then
      local waiting, valid = self:CheckGuideView(GuideOpType.Down)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveDown()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        DataCenter.LWBattleManager:SetGamePause(false)
      end
    elseif self.guidingType == GuideOpType.Left then
      local waiting, valid = self:CheckGuideView(GuideOpType.Left)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveLeft()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        DataCenter.LWBattleManager:SetGamePause(false)
      end
    elseif self.guidingType == GuideOpType.Right then
      local waiting, valid = self:CheckGuideView(GuideOpType.Right)
      if waiting then
        self.guidingWaiting = nil
        self:OnMoveRight()
        self.guidingType = nil
        self.curGuide = self.curGuide + 1
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
        DataCenter.LWBattleManager:SetGamePause(false)
      end
    end
    return
  end
  if not self.fingerDown then
    self.fingerDownPos = nil
    self:CheckGuideView(GuideOpType.Up)
    return
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
  end
end

function SurfingLogic:OnGuideFinish()
  if not self.isGuide then
    return
  end
  DataCenter.LWBattleManager:SetGameOver(true)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
  local rewarded = DataCenter.LWSurfingDataManager:IsGuideReward()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleGuideFinish, {anim = true}, {skip = false, rewarded = rewarded})
  DataCenter.LWSurfingDataManager:ReqGuideReward()
end

function SurfingLogic:CheckOffsetZ(newZ)
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

function SurfingLogic:ApplyResetOffsetZ()
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

function SurfingLogic:OnUpdatePause()
  local deltaTime = Time.unscaledDeltaTime
  self.totalPauseTime = self.totalPauseTime + deltaTime
  if self.state == Const.SurfingState.Ready then
    return
  end
  self:UpdateCheck(deltaTime)
  if self.isGuide then
    self:UpdateGuideOp()
  end
end

function SurfingLogic:UpdateCheck(deltaTime)
  if not self.checkValid or self.endGameMsgWaiting then
    return
  end
  self.checkTimer = self.checkTimer + deltaTime
  if self.checkTimer > CheckInterval then
    DataCenter.LWSurfingDataManager:ReqTimeCheck(self:GetUuid(), self:GetCurDistanceData(), self.totalRunTime, self.totalPauseTime)
    self.checkTimer = self.checkTimer - CheckInterval
  end
end

function SurfingLogic:TryCheckObj(bornId, monsterId, oriId)
  if not self.checkValid or self.endGameMsgWaiting then
    return
  end
  local metaMonsterId = 0 < oriId and oriId or monsterId
  DataCenter.LWSurfingDataManager:ReqMonsterCheck(self:GetUuid(), self:GetCurDistanceData(), self.totalRunTime, self.totalPauseTime, bornId, metaMonsterId, monsterId)
end

function SurfingLogic:Destroy()
  self:RemoveListeners()
  self:CloseWindows()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.envSoundHandle1 then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle1)
    self.envSoundHandle1 = nil
  end
  if self.envSoundHandle2 then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle2)
    self.envSoundHandle2 = nil
  end
  CS.SceneManager.ResetRollStrengthZ()
  self:UnInitCamera()
  PveUnitViewUtil.UnInitView()
  EffectViewUtil.UnInitView()
  self:RemoveSceneUpdator()
  self:RemoveLateUpdate()
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
  self.resurgenceTimes = nil
  self.resurgenceLimit = nil
  self.valid = false
  self.waitingLoad = nil
  self.loadingFinishMark = nil
  self.playbackSW = nil
  if self.surfingLogger then
    self.surfingLogger:Exit()
    self.surfingLogger:Delete()
    self.surfingLogger = nil
  end
  if self.data then
    self.data:Delete()
    self.data = nil
  end
end

function SurfingLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function SurfingLogic:RemoveListener(msg_name)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function SurfingLogic:LoadSkybox()
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

function SurfingLogic:UpdateSkybox()
  if self.skyboxValid and self.player then
    local pos = self.player:GetPosition()
    self.skyboxTrans:Set_localPosition(self.skyBoxX, 0, pos.z)
  end
end

function SurfingLogic:LoadSceneExt()
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

function SurfingLogic:PreloadUnit()
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/Surfing/Buff/O_Object_score_gold.prefab", 70)
  PveUnitViewUtil.Preload("Assets/Main/Prefabs/LWBattle/Surfing/Hero/A_Hero_surfing_ninja.prefab", 1)
end

function SurfingLogic:PreloadEffect()
  if not self.ignoreSpectacularEffect then
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_ljw_s4_running_gold_glow.prefab", 30)
  end
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chijinbi.prefab", 2)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_bianshen.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_jiasu.prefab", 1)
  EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_hudunposui.prefab", 1)
end

function SurfingLogic:CheckLoadFinish()
  self.loadingFinishMark = self.loadingFinishMark + 1
  if self.loadingFinishMark >= LOADING_FINISH_FLAG then
    self:LoadComplete()
  end
end

function SurfingLogic:LoadSceneComplete()
  local pos = self.data:GetBirthPos()
  self.battleMgr:LookAt(pos)
  self:FixCameraFar()
  self:AddSceneUpdator()
  self:AddLateUpdate()
end

function SurfingLogic:LoadComplete()
  self.initComplete = true
  if self.waitingLoad then
    self.waitingLoad = nil
    self:OnStart()
  end
end

function SurfingLogic:LoadSceneByCount(count, callBack)
  if not self.data then
    Logger.LogInfo("Surfing -- the logic data is nil")
    DataCenter.LWBattleManager:ShowTipsId("parkour_cheat_01")
    DataCenter.LWBattleManager:Exit()
    return
  end
  ProfilerUtil.BeginSample("SurfingLogic.LoadSceneByCount")
  local sceneConfigs = self.data:GetSceneConfigs(count)
  if table.IsNullOrEmpty(sceneConfigs) then
    Logger.LogInfo("Surfing -- cannot get scene configs")
    DataCenter.LWBattleManager:ShowTipsId("parkour_cheat_01")
    DataCenter.LWBattleManager:Exit()
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
    local data = SurfingSceneData.New(sceneCfg, lastZ + sceneCfg.sizeZ, lastZ, lastIndex + 1)
    if sceneCfg.endLine and self.endLine == nil then
      self.endLine = lastZ + sceneCfg.endLine
    end
    if sceneCfg.infiniteMark and self.infiniteZ == nil then
      self.infiniteZ = lastZ
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
    self.sceneCount = self.sceneCount + 1
  end
  ProfilerUtil.EndSample()
end

function SurfingLogic:CheckSceneData()
  return false
end

function SurfingLogic:UpdateMonsterMgr(sceneCfg)
  if sceneCfg and not string.IsNullOrEmpty(sceneCfg.farmMonster) then
    self.monsterMgr:ReInit(sceneCfg.farmMonster, sceneCfg.offset, sceneCfg.groupId)
  end
end

function SurfingLogic:GetLastSceneData()
  if self.scenes then
    local scene = self.scenes[#self.scenes]
    if scene then
      return scene.sceneData
    end
  end
  return nil
end

local function CheckSpeedChanged(self, curScene)
  if curScene then
    local config = curScene.sceneData.config
    local curSpeedZ = config.speed_z
    if self.speedZ ~= curSpeedZ then
      local showEffect = self.speedZ > 0
      self.speedZ = curSpeedZ
      self.player:SetMoveBase(config.baseTime, config.baseDistance, config.startSpeed, config.endSpeed)
      EventManager:GetInstance():Broadcast(EventId.SurfingOnMoveSpeedChanged, curSpeedZ)
      if showEffect then
        self.player:ShowUnitEffect(SurfingUnitEffectType.SpeedUp)
      end
    end
  end
end

local function CheckEndStage(self, curScene)
  if self.curScene == nil then
    return
  end
  if curScene == nil then
    Logger.LogInfo("surfing -- [CheckEndStage] curScene is nil")
    return
  end
  local oldIndex = self.curScene:GetActualIndex()
  local newIndex = curScene:GetActualIndex()
  if oldIndex ~= newIndex and self.stageIndex ~= oldIndex and 0 < oldIndex then
    self:EndStage(self.curScene:GetEndZ())
    self.stageIndex = oldIndex
    if self.data and self.data:CheckIds(oldIndex) then
      DataCenter.LWSurfingDataManager:ReqGetFollowupIds(self:GetUuid())
    end
  end
end

function SurfingLogic:UpdateScene()
  if self.scenes and self.data then
    local followZ = self:GetCurDistanceData()
    if self.curScene ~= nil and self.curScene:IsContainsZ(followZ) then
      if self.endLine ~= nil and followZ >= self.endLine then
        self:ChangeState(Const.SurfingState.Win)
      end
      ProfilerUtil.BeginSample("SurfingLogic.UpdateScene.Music")
      if self.infiniteZ ~= nil and followZ >= self.infiniteZ then
        self.infiniteZ = nil
        local meta = self.data and self.data.meta
        if meta then
          do
            local bgm_1 = meta.bgm_1
            local id1 = bgm_1[1]
            local delay = bgm_1[2] or 0
            delay = delay / 1000
            if not string.IsNullOrEmpty(id1) then
              local fadeTime = 0.3
              self.envSoundHandle1 = DataCenter.LWSoundManager:PlaySoundWithStartTime(tonumber(id1), fadeTime, true, fadeTime)
              if self.audioTimer then
                self.audioTimer:Stop()
                self.audioTimer = nil
              end
              self.audioTimer = TimerManager:GetInstance():DelayInvoke(function()
                local id2 = meta.bgm_2
                if not string.IsNullOrEmpty(id2) then
                  self.envSoundHandle2 = DataCenter.LWSoundManager:PlaySoundWithStartTime(tonumber(id2), 0, true, 0.01)
                end
              end, delay)
            end
          end
        end
      end
      ProfilerUtil.EndSample()
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
    ProfilerUtil.BeginSample("SurfingLogic.UpdateScene.CheckEndStage")
    CheckEndStage(self, curScene)
    ProfilerUtil.EndSample()
    self.curScene = curScene
    ProfilerUtil.BeginSample("SurfingLogic.UpdateScene.CheckSpeedChanged")
    CheckSpeedChanged(self, self.curScene)
    ProfilerUtil.EndSample()
    if self.isDebug then
      EventManager:GetInstance():Broadcast(EventId.SurfingSceneChanged, curScene)
    end
    if curScene == nil then
      local logStr = "Surfing -- " .. self:GetCurDistanceData() .. "\n"
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

function SurfingLogic:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function SurfingLogic:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function SurfingLogic:SceneUpdate()
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

function SurfingLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
  self:InitTouchInput()
end

function SurfingLogic:InitTouchInput()
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

function SurfingLogic:FixCameraFar()
  self.camera = self.battleMgr.camera
  if self.camera then
    self.camera.farClipPlane = 200
  end
end

function SurfingLogic:UnInitCamera()
  self:UnInitTouchInput()
end

function SurfingLogic:UnInitTouchInput()
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

function SurfingLogic:InitCameraParams()
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

function SurfingLogic:GetCameraParam()
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

function SurfingLogic:UpdateCameraFollow(deltaTime)
  if self.state ~= Const.SurfingState.Surfing then
    return
  end
  local teamPosX, teamPosY, teamPosZ = self.player:GetCameraFollowXYZ()
  if teamPosZ == nil then
    return
  end
  tmpV2:Set(teamPosX, teamPosY, teamPosZ + LookOffset)
  self.battleMgr:CameraFollowLookAt(tmpV2, 8, 15, deltaTime)
end

function SurfingLogic:OnFingerDown(pos)
  if self.state == Const.SurfingState.Ready then
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
  self:AppendLog("[" .. Time.frameCount .. "]" .. "FingerDown ")
end

function SurfingLogic:OnFingerUp()
  self.fingerDown = false
  self:AppendLog("[" .. Time.frameCount .. "]" .. "FingerUp ")
end

function SurfingLogic:CheckInputDir()
  if self.fingerDown then
    local touchInput = self.touchCamera.touchInput
    local curPos = touchInput:GetFingerDownPosition()
    local hor = curPos.x - self.fingerDownPos.x
    local ver = curPos.y - self.fingerDownPos.y
    local absHor = Mathf.Abs(hor)
    local absVer = Mathf.Abs(ver)
    self:AppendLog("[" .. Time.frameCount .. "]" .. " CheckInputDir: " .. hor .. " -- " .. ver)
    if absHor <= TouchThreshold and absVer <= TouchThreshold then
      return
    end
    self.fingerDown = false
    if absHor > absVer then
      if 0 < hor then
        self:OnMoveRight()
      else
        self:OnMoveLeft()
      end
    elseif 0 < ver then
      self:OnMoveUp()
    else
      self:OnMoveDown()
    end
  end
end

function SurfingLogic:OnMoveLeft()
  self:AppendLog("[" .. Time.frameCount .. "]" .. " MoveLeft ")
  if self.player then
    return self.player:OnMoveLeft()
  end
end

function SurfingLogic:OnMoveRight()
  self:AppendLog("[" .. Time.frameCount .. "]" .. " MoveRight ")
  if self.player then
    return self.player:OnMoveRight()
  end
end

function SurfingLogic:OnMoveUp()
  self:AppendLog("[" .. Time.frameCount .. "]" .. " MoveUp ")
  if self.player then
    return self.player:OnMoveUp()
  end
end

function SurfingLogic:OnMoveDown()
  self:AppendLog("[" .. Time.frameCount .. "]" .. " MoveDown ")
  if self.player then
    return self.player:OnMoveDown()
  end
end

function SurfingLogic:OnFingerHold(deltaTime)
  if self.state == Const.SurfingState.Ready then
    return
  end
  if self.isGuide then
    return
  end
  self:CheckInputDir()
end

function SurfingLogic:InitInviteAllyData(param)
  if param then
    local inviteUsers = param.inviteUsers
    if self.gm or param.enterType == PVEEnterType.Guide then
      inviteUsers = DataCenter.LWSurfingDataManager:GetInvitePlayers()
    end
    local invitePlayers = inviteUsers
    self.oriInvitePlayers = invitePlayers
    self.invitePlayerNum = invitePlayers and #invitePlayers or 0
    local p1, p2 = DataCenter.LWSurfingDataManager:GetAllianceHelpParam()
    if invitePlayers and 0 < p1 then
      self.invitePlayers = {}
      for _, v in ipairs(invitePlayers) do
        table.insert(self.invitePlayers, {
          uid = v.uid,
          playerInfo = v,
          num = p1 or 0
        })
      end
    end
    self.extraPlayerNum = p2 or 0
    self.remainPlayerNum = self.invitePlayerNum * (p1 or 0) + self.extraPlayerNum
  end
end

function SurfingLogic:AddListeners()
  self:AddListener(EventId.SurfingFightOnFailed, self.OnFailureHandler)
  self:AddListener(EventId.SurfingFightOnStageStop, self.OnGameStageStop)
  self:AddListener(EventId.SurfingOnBattleFinished, self.OnGameBattleFinished)
  self:AddListener(EventId.SurfingFightOnRefreshIds, self.OnGameSceneIdsRefresh)
  self:AddListener(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:AddListener(EventId.OpenUI, self.OnOpenUIAction)
  self:AddListener(EventId.CloseUI, self.OnCloseUIAction)
  self:AddListener(EventId.SurfingOnGetRebirthInfo, self.OnGetRebirthInfo)
  self:AddListener(EventId.Guide_video_Play, self.OnLoadSceneFinished)
end

function SurfingLogic:RemoveListeners()
  self:RemoveListener(EventId.SurfingFightOnFailed)
  self:RemoveListener(EventId.SurfingFightOnStageStop)
  self:RemoveListener(EventId.SurfingOnBattleFinished)
  self:RemoveListener(EventId.SurfingFightOnRefreshIds)
  self:RemoveListener(EventId.APP_APPLICATION_PAUSE)
  self:RemoveListener(EventId.OpenUI)
  self:RemoveListener(EventId.CloseUI)
  self:RemoveListener(EventId.SurfingOnGetRebirthInfo)
  self:RemoveListener(EventId.Guide_video_Play)
end

function SurfingLogic:OnStart()
  self:RemoveSceneUpdator()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
  self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UISurfingBattleMain).View
  if not self.isGuide and DataCenter.LWSurfingDataManager:GetIsFirstEnterGame() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingGuild, {anim = false})
    DataCenter.LWSurfingDataManager:SetIsFirstEnterGame()
  end
  self:ChangeState(Const.SurfingState.Surfing)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Whistle, false)
  self.battleMgr:SetGameStart(true)
end

function SurfingLogic:ChangeState(newState)
  local oldState = self.state
  if newState == Const.SurfingState.Ready then
    self.state = newState
  elseif newState == Const.SurfingState.Surfing then
    self.state = newState
    self.player:ChangeState(Const.SurfingState.Surfing)
  elseif newState == Const.SurfingState.Win then
    if oldState ~= Const.SurfingState.Surfing then
      return
    end
    self.state = newState
    self.battleMgr:SetGameOver(true)
  elseif newState == Const.SurfingState.Lose then
    if oldState == Const.SurfingState.Ready or oldState == Const.SurfingState.Win or oldState == Const.SurfingState.Lose then
      Logger.LogInfo("surfing -- [ChangeState] change to Lose failed, oldState = " .. oldState)
      return
    end
    self.state = newState
    self.battleMgr:SetGameOver(true)
    self:EndGame()
    if self.isDebug and GMUtils.GetBool(GMConst.SurfingLogOutput, false) then
      local log = self.player:GetDebugLog()
      Logger.Log(log)
      self:Log()
    end
  elseif newState == Const.SurfingState.Pause then
    if oldState ~= Const.SurfingState.Surfing then
      return
    end
    self.battleMgr:SetGamePause(true)
    self.state = newState
  end
  EventManager:GetInstance():Broadcast(EventId.SurfingOnGameStateChanged, self.state)
end

function SurfingLogic:CloseWindows()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingGuild) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingGuild)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleMain) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleMain)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattlePause) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattlePause)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleFailure) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleFailure)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleCountDown) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleCountDown)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuideFinish)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
end

function SurfingLogic:GetOffsetZ(height, rotation)
  return height / math_tan(rotation * math_pi / 180)
end

function SurfingLogic:AddLateUpdate()
  if self.lateUpdateTimer == nil then
    function self.lateUpdateTimer()
      self:OnLateUpdate()
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateTimer)
  end
end

function SurfingLogic:RemoveLateUpdate()
  if self.lateUpdateTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateTimer)
    self.lateUpdateTimer = nil
  end
end

function SurfingLogic:OnLateUpdate()
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

function SurfingLogic:CheckUpdateDecoration()
  if self.isDecorationMeshOpen then
    return not self.ultraLowDevice
  end
  return not self.lowDevice
end

function SurfingLogic:RecordGoods(type, goodsId, goodsCount)
  if not self.goods[type] then
    self.goods[type] = {}
    self.goods[type].count = -72
    self.goods[type].id = goodsId
  end
  self.goods[type].count = self.goods[type].count + goodsCount
end

function SurfingLogic:RecordPlayers(uid)
  if string.IsNullOrEmpty(uid) then
    Logger.LogInfo("surfing -- [RecordPlayers] uid is nil or empty")
    return
  end
  if self.recordPlayers == nil then
    self.recordPlayers = {}
  end
  if self.recordPlayers[uid] == nil then
    self.recordPlayers[uid] = 1
  else
    self.recordPlayers[uid] = self.recordPlayers[uid] + 1
  end
end

function SurfingLogic:OnApplicationPause(isPaused)
  if self.isGuide then
    return
  end
  if isPaused and (self.state and self.state == Const.SurfingState.Ready or self.state == Const.SurfingState.Surfing) then
    self:Pause(true)
  end
end

function SurfingLogic:OnOpenUIAction(uiName)
  if self.isGuide then
    return
  end
  if uiName == UIWindowNames.UIDisconnect then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      return
    end
    self:PauseGame()
  end
end

function SurfingLogic:OnCloseUIAction(uiName)
  if self.isGuide then
    return
  end
  if uiName == UIWindowNames.UIDisconnect then
    if self.waitRebirthInfo then
      self:RebirthInfo()
    elseif self.waitRebirth then
      self:RebirthGame()
    elseif self.endGameMsgWaiting then
      self:EndGame()
    end
  end
end

function SurfingLogic:OnGetRebirthInfo(message)
  self.waitRebirthInfo = false
  if message and message.errorCode == nil and message.uuid == self:GetUuid() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleFailure, {anim = true}, message)
  end
end

function SurfingLogic:OnFailureHandler(message)
  self.waitRebirth = false
  if message == nil then
    Logger.LogError("Surfing -- [OnFailureHandler] parkour.fight.rebirth error: message is nil")
    return
  end
  if message.uuid ~= self:GetUuid() then
    Logger.LogError("Surfing -- [OnFailureHandler] uuid cannot match, message.uuid = " .. (message.uuid or "") .. ", self.uuid = " .. (self:GetUuid() or ""))
    return
  end
  local errCode = message.errorCode
  if errCode == nil then
    local code = message.code
    if code == 0 then
      self:Resurgence()
      return
    end
  end
  self:ChangeState(Const.SurfingState.Lose)
end

function SurfingLogic:OnGameStageStop(t)
  if t and t.uuid == self:GetUuid() then
    DataCenter.LWBattleManager:SetGameOver(true)
    if self.battleMgr then
      self:ExitSurfing()
      self.battleMgr:Exit(nil, "lose")
    end
  end
end

function SurfingLogic:OnGameBattleFinished(t)
  self:Track(t)
  self.endGameMsgWaiting = false
  if t == nil then
    Logger.LogError("Surfing -- [OnGameBattleFinished] end game message info is nil")
    return
  end
  if t.uuid ~= self:GetUuid() then
    Logger.LogError("Surfing -- [OnGameBattleFinished] uuid cannot match, message.uuid = " .. (t.uuid or "") .. ", self.uuid = " .. (self:GetUuid() or ""))
    return
  end
  DataCenter.LWBattleManager:SetGameOver(true)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
    if self.battleMgr then
      self:ExitSurfing()
      self.battleMgr:Exit(nil, "lose")
    end
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleResult) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleResult)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuideFinish)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleGuide)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattleResult, {anim = true}, t)
  self:SaveLog()
end

function SurfingLogic:OnLoadSceneFinished()
  CS.SceneManager.SetRollStrengthZ(0.6)
  CS.SceneManager.SetRollStrengthX(0, -18, 0.8)
  self:FixCameraFar()
end

function SurfingLogic:Track(t)
  if t then
    local uuid = t.uuid or 0
    local distance = t.distance or 0
    local coin = t.coin or 0
    local box = t.box or 0
    local stageId = t.stageId or 0
    local id = t.id or 0
    local totalHelpNum = t.totalHelpNum or 0
    local totalRunTime = t.totalRunTime or 0
    local avgFPS = self:GetAvgFPS()
    local lowestFPS = self:GetLowestFPS()
    local highestFps = CS.UnityEngine.Application.targetFrameRate
    local posX = self.player and self.player:GetPosition().x or 0
    local posZ = self:GetCurDistanceData()
    PostEventLog.Track(PostEventLog.Defines.SURFING_GAMING_ON_END, {
      uuid = tostring(uuid),
      stageCostTime = totalRunTime,
      finalvalue = distance,
      int_para1 = coin,
      picking_score = totalHelpNum,
      int_para2 = box,
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

function SurfingLogic:GetAvgFPS()
  if self.frameTimer == 0 then
    return -1
  end
  return self.frames / self.frameTimer
end

function SurfingLogic:GetLowestFPS()
  return math.min(self.lowestFps, self:GetAvgFPS())
end

function SurfingLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function SurfingLogic:RemoveUnit(guid)
  if self.isMemoryPoolOpen then
    self.unitMgr:RemoveUnitTotalById(guid)
  else
    self.unitMgr:RemoveUnitById(guid)
  end
end

function SurfingLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function SurfingLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function SurfingLogic:GetMoveSpeed()
  return self.speedZ
end

function SurfingLogic:DealDamage(attacker, defender, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, exValue)
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
  self.makeDmg = self.makeDmg or 0
  self.makeDmg = self.makeDmg + hurt
end

function SurfingLogic:OnPlayerDeath()
  if self.resurgenceLimit == nil then
    self.resurgenceLimit = DataCenter.LWSurfingDataManager:GetResurgenceLimit()
  end
  if self.resurgenceTimes >= self.resurgenceLimit then
    self:ChangeState(Const.SurfingState.Lose)
    self:LogDeadline(EXIT_FLAGS.LOSE)
  else
    self:ChangeState(Const.SurfingState.Pause)
    self:RebirthInfo()
  end
end

function SurfingLogic:GetPropsId()
  return self.data.meta.goods
end

function SurfingLogic:GetCurDistanceData()
  local z = self.player and self.player:GetPosition().z or 0
  return z - self.renderOffsetZ
end

function SurfingLogic:GetCurDistanceView()
  local z = self.player and self.player:GetPosition().z or 0
  return z
end

function SurfingLogic:GetMonster(guid)
  return self.monsterMgr:GetMonster(guid)
end

function SurfingLogic:GetScoreMultiplier()
  return self.player.scoreMultiplier
end

function SurfingLogic:ClearMonstersByOffset()
  local pos = self.player:GetPosition()
  local posZ = pos.z
  self.monsterMgr:ClearMonstersByOffset(posZ + ClearMonsterOffset)
end

function SurfingLogic:GetUuid()
  return self.param and self.param.uuid
end

function SurfingLogic:OnGameSceneIdsRefresh(message)
  if message == nil then
    Logger.LogInfo("surfing -- [OnGameSceneIdsRefresh] message is nil")
    return
  end
  if message.uuid ~= self:GetUuid() then
    Logger.LogError("Surfing -- [OnGameSceneIdsRefresh] uuid cannot match, message.uuid = " .. (message.uuid or "") .. ", self.uuid = " .. (self:GetUuid() or ""))
    return
  end
  local totalSize = message.totalSize
  if totalSize > self.data:GetCurTotalIndex() then
    local ids = message.ids
    if ids then
      self.data:InsertIds(ids)
    end
  end
end

function SurfingLogic:GetSwitchMonsterId()
  return self.data:GetSwitchMonsterId()
end

function SurfingLogic:GetRemainHelpTimes()
  return self.remainPlayerNum > 0
end

function SurfingLogic:GetRandomPlayer()
  if self.remainPlayerNum > 0 then
    if self.remainPlayerNum > self.extraPlayerNum and self.invitePlayers then
      local count = #self.invitePlayers
      local r = 0
      if count == 1 then
        r = 1
      elseif 0 < count then
        r = math.random(1, count)
      end
      if 0 < r then
        local player = self.invitePlayers[r]
        if player then
          if 0 < player.num then
            self:UpdateRemainPlayers(player.playerInfo.uid)
            return player.playerInfo
          end
          table.remove(self.invitePlayers, r)
          return self:GetRandomPlayer()
        end
      end
    end
    if self.oriInvitePlayers then
      local count = #self.oriInvitePlayers
      local r = 0
      if count == 1 then
        r = 1
      elseif 0 < count then
        r = math.random(1, count)
      end
      if 0 < r then
        local playerInfo = self.oriInvitePlayers[r]
        if playerInfo then
          self:UpdateRemainPlayers(playerInfo.uid)
          return playerInfo
        end
      end
    end
  end
end

function SurfingLogic:UpdateRemainPlayers(uid)
  if string.IsNullOrEmpty(uid) then
    Logger.LogInfo("surfing -- [UpdateRemainPlayers] uid is nil")
    return
  end
  if self.remainPlayerNum > 0 then
    local removeIndex = 0
    local remove = false
    if self.remainPlayerNum > self.extraPlayerNum then
      for i, v in ipairs(self.invitePlayers) do
        if v.uid == uid then
          local num = self.invitePlayers[i].num
          num = num - 1
          self.invitePlayers[i].num = num
          remove = true
          if num <= 0 then
            removeIndex = i
          end
          break
        end
      end
      if 0 < removeIndex then
        table.remove(self.invitePlayers, removeIndex)
      end
      if remove then
        self.remainPlayerNum = self.remainPlayerNum - 1
      end
    else
      self.remainPlayerNum = self.remainPlayerNum - 1
    end
  end
end

function SurfingLogic:CheckRemainBox()
  if self.showBoxRemain == nil then
    local curNum, max = DataCenter.LWSurfingDataManager:GetDailyBoxNum()
    self.showBoxRemain = max - curNum
  end
  return self.showBoxRemain > 0
end

function SurfingLogic:UpdateRemainBox()
  if self.showBoxRemain == nil then
    local curNum, max = DataCenter.LWSurfingDataManager:GetDailyBoxNum()
    self.showBoxRemain = max - curNum
  end
  if self.showBoxRemain > 0 then
    self.showBoxRemain = self.showBoxRemain - 1
  end
end

function SurfingLogic:PauseGame()
  self:Pause(true)
end

function SurfingLogic:GetGameScore()
  local addCoin = self.goods and self.goods[SurfingGoodsType.Score] and self.goods[SurfingGoodsType.Score].count or -72
  return addCoin
end

function SurfingLogic:RebirthGame()
  local addCoin = self.goods and self.goods[SurfingGoodsType.Score] and self.goods[SurfingGoodsType.Score].count or -72
  local box = self.goods and self.goods[SurfingGoodsType.Box] and self.goods[SurfingGoodsType.Box].count or -72
  local actualIndex = self.curScene and self.curScene:GetActualIndex()
  self.waitRebirth = DataCenter.LWSurfingDataManager:ReqRebirthGame(self:GetUuid(), self:GetCurDistanceData(), addCoin + 75, box + 72, self.resurgenceTimes + 1, actualIndex)
  Logger.LogInfo(string.format("Surfing -- [RebirthGame] player distance:%s totalRunTime :%s totalStopTime :%s", self:GetCurDistanceData(), self.totalRunTime, self.totalPauseTime))
end

function SurfingLogic:Resurgence()
  if self.resurgenceTimes < self.resurgenceLimit then
    self:ChangeState(Const.SurfingState.Surfing)
    self.resurgenceTimes = self.resurgenceTimes + 1
    self.player:ShowUnitEffect(SurfingUnitEffectType.Resurgence)
    self.player:Resurgence()
    self.battleMgr:SetGamePause(false)
    self:ClearMonstersByOffset()
    self:LogDeadline(EXIT_FLAGS.RESURGENCE)
  end
end

function SurfingLogic:EndGame()
  self:LogDeadline(EXIT_FLAGS.LOSE)
  if self.curScene then
    local actualIndex = self.curScene:GetActualIndex()
    local id = self.curScene:GetId()
    local addCoin = self.goods and self.goods[SurfingGoodsType.Score] and self.goods[SurfingGoodsType.Score].count or -72
    local box = self.goods and self.goods[SurfingGoodsType.Box] and self.goods[SurfingGoodsType.Box].count or -72
    local currentInt = self:GetCurDistanceData()
    self.endGameMsgWaiting = DataCenter.LWSurfingDataManager:ReqEndGame(self:GetUuid(), actualIndex, id, currentInt, addCoin + 75, box + 72, self.recordPlayers, self.totalRunTime)
  end
end

function SurfingLogic:EndStage(endZ)
  if self.endGameMsgWaiting then
    return
  end
  if self.curScene then
    local actualIndex = self.curScene:GetActualIndex()
    local id = self.curScene:GetId()
    local addCoin = self.goods and self.goods[SurfingGoodsType.Score] and self.goods[SurfingGoodsType.Score].count or -72
    local box = self.goods and self.goods[SurfingGoodsType.Box] and self.goods[SurfingGoodsType.Box].count or -72
    DataCenter.LWSurfingDataManager:ReqEndStage(self:GetUuid(), actualIndex, id, endZ, addCoin + 75, box + 72, self.recordPlayers)
  end
end

function SurfingLogic:RebirthInfo()
  local addCoin = self.goods and self.goods[SurfingGoodsType.Score] and self.goods[SurfingGoodsType.Score].count or -72
  local currentInt = Mathf.Floor(self:GetCurDistanceData())
  self.waitRebirthInfo = DataCenter.LWSurfingDataManager:ReqRebirthInfo(self:GetUuid(), addCoin + 75, currentInt)
  Logger.LogInfo(string.format("Surfing -- [RebirthInfo] player distance:%s totalRunTime :%s totalStopTime :%s", self:GetCurDistanceData(), self.totalRunTime, self.totalPauseTime))
end

function SurfingLogic:Pause(pause)
  if pause then
    self:ChangeState(Const.SurfingState.Pause)
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleCountDown) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleCountDown)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleFailure) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleResult) or self.waitRebirthInfo or self.waitRebirth or self.endGameMsgWaiting then
      return
    end
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattlePause) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingBattlePause, {anim = true})
    end
  else
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingBattleCountDown) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingBattleCountDown)
    end
    self:ChangeState(Const.SurfingState.Surfing)
    self.battleMgr:SetGamePause(false)
  end
end

function SurfingLogic:ShowEffectObj(path, pos, rot, time, parent, type)
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

function SurfingLogic:ShowEffectParent(id, parent)
  if not id then
    return
  end
  EffectViewUtil.ShowEffectParent(id, parent)
end

function SurfingLogic:ResetEffectPosition(id, x, y, z)
  if not id then
    return
  end
  EffectViewUtil.ResetPosition(id, x, y, z)
end

function SurfingLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function SurfingLogic:CalculateCreateDis(duration)
  local speed = self.speedZ
  return speed * duration
end

function SurfingLogic:GetTakeOffOffset()
  local height = self.player.flyHeight
  local speed = self.player.flySpeed
  local time = height / speed
  return self.speedZ * (time + 1)
end

function SurfingLogic:ShowSkyScores(offsetZ, duration)
  if self.data == nil or duration == 0 then
    return
  end
  local bornArr = self.data:GetSkyScoreData()
  local dis = self:CalculateCreateDis(duration)
  local offset = self:GetTakeOffOffset()
  if self.monsterMgr then
    self.monsterMgr:CreateSkyScores(bornArr, offsetZ + offset, dis - offset)
  end
end

function SurfingLogic:RemoveSkyScores()
  if self.monsterMgr then
    self.monsterMgr:RemoveSkyScores()
  end
end

function SurfingLogic:GetStageId()
  return self.data and self.data.metaId or 0
end

function SurfingLogic:AppendLog(log)
  if self.logCache == nil then
    self.logCache = {}
  end
  table.insert(self.logCache, log)
end

function SurfingLogic:Log()
  if self.logCache then
    local str = table.concat(self.logCache, "\n")
    Logger.Log("Surfing Log: \n" .. str)
    if self.isDebug and not self.isEditor then
      local path = CS.UnityEngine.Application.persistentDataPath .. "/surfingLog.txt"
      local f = io.open(path, "w")
      if f then
        f:write("Surfing Log: \n" .. str)
        f:close()
      end
    end
    self.logCache = nil
  end
end

function SurfingLogic:ExitSurfing()
  if self.playbackSW then
    if self.isEditor or self.isDebug then
      self:LogDeadline(EXIT_FLAGS.EXIT)
      self:SaveLog()
    else
      self:ExitDelFile()
    end
  end
end

function SurfingLogic:SetInvincible(isOn)
  self.player:SetInvincible(isOn)
end

function SurfingLogic:SetOldOption(isOn)
  self.oldOption = isOn
  self.player.oldOption = isOn
end

function SurfingLogic:SetJumpVo(value)
  self.player.jumpVoValue = value
end

function SurfingLogic:SetGravity(value)
  self.player.gravityValue = value
end

function SurfingLogic:SetHeightLimit(value)
  self.player.heightLimitValue = value
end

function SurfingLogic:SetJumpDuration(value)
  self.player.jumpDurationValue = value
end

function SurfingLogic:SetCurveTopParam(value)
  self.player.curveTopParamValue = value
end

function SurfingLogic:GetOldOption()
  return self.player.oldOption
end

function SurfingLogic:GetJumpVo()
  return self.player.jumpVoValue
end

function SurfingLogic:GetGravity()
  return self.player.gravityValue
end

function SurfingLogic:GetHeightLimit()
  return self.player.heightLimitValue
end

function SurfingLogic:GetJumpDuration()
  return self.player.jumpDurationValue
end

function SurfingLogic:GetCurveTopParam()
  return self.player.curveTopParamValue
end

function SurfingLogic:LogStageId(levelId)
  if self.playbackSW then
    self.surfingLogger:LogStageId(levelId, self:GetUuid(), UITimeManager:GetInstance():GetServerSeconds())
  end
end

function SurfingLogic:LogSceneIds(sceneId)
  if self.playbackSW then
    self.surfingLogger:LogSceneIds(sceneId)
  end
end

function SurfingLogic:LogPlayerInput(input)
  if self.playbackSW then
    self.surfingLogger:LogInput(input, self.totalRunTime)
  end
end

function SurfingLogic:LogMonsterObj(index, level, mId)
  if self.playbackSW then
    self.surfingLogger:LogMonsterObj(index, level, mId)
  end
end

function SurfingLogic:LogDeadline(flag)
  if self.playbackSW then
    self.surfingLogger:LogDeadline(flag, self:GetCurDistanceData(), self.totalRunTime)
  end
end

function SurfingLogic:SaveLog()
  if not self.playbackSW then
    return
  end
  if self.surfingLogger then
    ProfilerUtil.BeginSample("SurfingLogic:SaveLog")
    self.surfingLogger:Save()
    ProfilerUtil.EndSample()
  end
end

function SurfingLogic:ExitDelFile()
  if not self.playbackSW then
    return
  end
  if self.surfingLogger then
    self.surfingLogger:Exit()
  end
end

return SurfingLogic
