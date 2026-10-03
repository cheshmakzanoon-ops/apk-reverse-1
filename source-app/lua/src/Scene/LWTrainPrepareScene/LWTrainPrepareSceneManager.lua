local LWTrainPrepareSceneManager = BaseClass("LWTrainPrepareSceneManager")
local Resource = CS.GameEntry.Resource
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Plane = _ENV.Plane
local Touch = CS.BitBenderGames.TouchWrapper
local Screen = CS.UnityEngine.Screen
local LWTrainPrepareScenePassengers = require("Scene.LWTrainPrepareScene.LWTrainPrepareScenePassengers")
local BuildBubbleTip = require("UI.BuildBubbleTip.View.BuildBubbleTip")
local ChangeEffectPath = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Train/Eff_Train_Change.prefab"
local ChangeEffectPath2 = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Train/Eff_Train_Change_01.prefab"
local TrainEnterEffect = "Assets/_Art_LastWar/Effect/Prefab/Zhucheng/Eff_Smoke_begin.prefab"
local SceneX = -1000
local SceneY = 0
local SceneZ = -1000
local maxZ = 36
local minZ = -2
local cameraX = 31.93
local cameraY = 42.41
local cameraRotX = 90
local cameraAnimStartY = 14.9
local cameraAnimStartZ = -64
local cameraAnimStartRotX = 53.087
local DISPLACE_EPSILON = 0.01
local trainRootAnimStartZ = -66.2
local trainRootAnimEndZ = 0
local driverBubbleOffsetFrom = -3
local driverBubbleOffsetTo = 0
local CarriagePrefabPath = {
  [1] = "Assets/_Art_LastWar/Models/Environment/Build/A_build_Train_01/prefab/A_build_train_01_chetou.prefab",
  [2] = "Assets/_Art_LastWar/Models/Environment/Build/A_build_Train_01/prefab/A_build_train_01_chexiang1.prefab"
}
local CarriageOffset = {
  -1.5,
  0,
  0,
  0,
  0,
  -2.5
}
local CarriagePrefabPathUR = {
  [1] = "Assets/_Art_LastWar/Models/Environment/Build/Huoche_UR/prefab/train_head_UR_ding.prefab",
  [2] = "Assets/_Art_LastWar/Models/Environment/Build/Huoche_UR/prefab/train_cabin_UR_ding.prefab"
}
local CarriageOffsetUR = {0}

function LWTrainPrepareSceneManager:__init()
  self.dataValid = false
  self.sceneLoaded = false
  self.acceptVip = false
  self.acceptVipInfo = false
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
end

function LWTrainPrepareSceneManager:__delete()
  self.onFingerDown = nil
  self.onFingerUp = nil
  self:Destroy()
end

function LWTrainPrepareSceneManager:Destroy()
  self.dataValid = false
  self.sceneLoaded = false
  self.forceEnter = false
  self.trainPrepare = nil
  self.moveTime = nil
  self.parkList = nil
  self.parkAnimList = nil
  self.parkSlotList = nil
  self.coachRootList = nil
  self.cfgId = nil
  self.controlCameraTrans = nil
  self.controlCamera = nil
  self.carriageList = nil
  self.trainRoot = nil
  self.trainAnim = nil
  self.driver = nil
  self.driverBubble = nil
  self.tail = nil
  self.randomToggleRoot = nil
  self.showTrainEnter = false
  self.cameraAnim = nil
  self.cameraShakeAnim = nil
  self.VIPRoot = nil
  if self.VIPBubble then
    self.VIPBubble:OnDestroy()
    self.VIPBubble = nil
  end
  self.acceptVip = nil
  self.acceptVipInfo = nil
  self:RemoveUpdateTimer()
  if self.inputManager then
    self.inputManager:UnInit()
    self.inputManager = nil
  end
  self:ClearDelayEnter()
  self:ClearDriverAnimTimer()
  self:ClearDelayDriverAnim()
  self:ClearTrainEnterFinishTimer()
  self:ClearTrainEnterEffect()
  self:ClearTrainChangeEffect()
  self:ClearTrainChangeEffect2()
  self:ClearDelayReloadTrainSequence()
  self:UnloadScene()
  self.posArray = nil
end

local function ProtectCall(fun)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
end

function LWTrainPrepareSceneManager:Enter(trainPrepare)
  if self.dataValid then
    return
  end
  local prefabPath = DataCenter.LWAllyStationDataManager:GetPrepareScenePath()
  if string.IsNullOrEmpty(prefabPath) then
    Logger.LogError("LWTrainPrepareSceneManager:Enter prefabPath invalid ! ")
    return
  end
  self.dataValid = true
  self.sceneLoaded = false
  self.forceEnter = false
  self.reloadingTrain = false
  self.passengersBubbleTimer = nil
  self.trainPrepare = trainPrepare
  self.curPage = TrainPreparePage.Passenger
  if CS.SceneManager.World then
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
  end
  ProtectCall(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
  end)
  ProtectCall(function()
    GoToUtil.CloseAllWindows()
  end)
  ProtectCall(function()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  end)
  ProtectCall(function()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  end)
  if CS.SceneManager.IsInCity() then
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
  elseif CS.SceneManager.IsInWorld() then
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
  end
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
  self:LoadScene(prefabPath)
  if self.posArray == nil then
    self.posArray = {
      {9.921019554138184, 1.6229376792907715},
      {9.541253089904785, 2.548020124435425},
      {8.975702285766602, 1.2841793298721313},
      {8.599811553955078, 2.210843563079834},
      {8.45916748046875, 0.40406471490859985},
      {7.792018890380859, 2.9585790634155273},
      {7.636110305786133, 0.972023606300354},
      {7.628754138946533, 1.9719966650009155},
      {7.307475566864014, 0.027566321194171906},
      {6.676380157470703, 2.2769293785095215},
      {6.480192184448242, 0.9046640992164612},
      {5.767061710357666, 2.69303035736084},
      {5.515072822570801, 0.6428533792495728},
      {5, 1.5},
      {4.790496349334717, 2.4778079986572266},
      {4.709922790527344, 0.0022307788021862507},
      {4.220123767852783, 0.874066174030304},
      {3.876683473587036, 2.883943796157837},
      {3.229506492614746, 0.7374003529548645},
      {3.026994466781616, 2.356659412384033},
      {2.549821615219116, 1.4709047079086304},
      {2.2958791255950928, 0.3791544735431671},
      {2.241069793701172, 2.9749817848205566},
      {1.3607107400894165, 0.7333581447601318},
      {1.296260952949524, 2.6473593711853027},
      {0.9938912987709045, 1.663650393486023},
      {0.2976797819137573, 2.5941059589385986}
    }
  end
end

function LWTrainPrepareSceneManager:TryExit()
  if self.dataValid and not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    self:Exit()
  end
end

function LWTrainPrepareSceneManager:Exit()
  DataCenter.LWSoundManager:StopAllSounds()
  self:Destroy()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepareScene)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainPrepareReplace)
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local function onSceneCreated()
      DataCenter.WarningBallManager:AddTimer()
      
      EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      DataCenter.CityNpcManager:SetNpcVisible(true)
      DataCenter.GuideManager:DoWaitTriggerAfterBack()
      DataCenter.LWMyStationManager:TryMoveCameraLookAtTrainStation()
      EventManager:GetInstance():Broadcast(EventId.UpdateActivityAlarmClockData)
    end
    
    SceneUtils.CreateCity()
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
end

function LWTrainPrepareSceneManager:LoadScene(prefabPath)
  if self.sceneLoadRequest then
    return
  end
  self.sceneLoaded = false
  self.sceneLoadTime = Time.realtimeSinceStartup
  local req = Resource:InstantiateAsync(prefabPath)
  req:completed("+", function()
    if not self.dataValid then
      req:Destroy()
      return
    end
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(SceneX, SceneY, SceneZ)
    self:OnSceneLoadFinish(sceneRoot)
  end)
  self.sceneLoadRequest = req
end

function LWTrainPrepareSceneManager:CheckLoadingState()
  if not self.dataValid then
    return true
  end
  if self.sceneLoadRequest == nil then
    return true
  end
  if self.sceneLoaded then
    ProtectCall(function()
      if self.dataValid and self.showTrainEnter then
        self:DelayEnter(0.7)
        return
      end
      if self.dataValid and self.showDriver then
        self:DelayDriverAnim(0.7)
        return
      end
    end)
    return true
  end
  local t = Time.realtimeSinceStartup
  local ret = t - self.sceneLoadTime > 2
  if ret then
    self.forceEnter = true
  end
  return ret
end

function LWTrainPrepareSceneManager:OnSceneLoadFinish(sceneRoot)
  self.sceneLoaded = true
  self.controlCameraTrans = sceneRoot:Find("CameraRoot/Camera")
  if self.controlCameraTrans == nil then
    Logger.LogError("LWTrainPrepareSceneManager:OnSceneLoadFinish main camera transform invalid !")
    return
  end
  self.cameraAnim = self.controlCameraTrans:GetComponent(typeof(CS.SimpleAnimation))
  if self.cameraAnim ~= nil then
    self.cameraAnim.enabled = false
  end
  self.controlCamera = self.controlCameraTrans:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  if self.controlCamera == nil then
    Logger.LogError("LWTrainPrepareSceneManager:OnSceneLoadFinish main camera component invalid !")
    return
  end
  self.cameraShakeAnim = self.controlCamera.transform:GetComponent(typeof(CS.SimpleAnimation))
  if self.cameraShakeAnim ~= nil then
    self.cameraShakeAnim.enabled = false
  end
  ProtectCall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.Custom
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(CustomSceneSubType, CustomSceneSubType.PrepareTrain)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.Custom)
  CommonUtil.PlayGameBgMusic()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  local showDriver = false
  local showTrainEnter = false
  local showVip = false
  if trainData then
    if not string.IsNullOrEmpty(trainData.ownerId) then
      local key = "TRAIN_DRIVER_ANIM"
      local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
      if trainData.uuid ~= trainUuid then
        CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
        showDriver = true
      end
      local vipKey = "TRAIN_VIP_ANIM"
      local trainVipUuid = CommonUtil.PlayerPrefsGetLong(vipKey, 0)
      if trainData.uuid ~= trainVipUuid and trainData.vipInfo and trainData.vipInfo.vipType == TrainVipType.isBigBro then
        CommonUtil.PlayerPrefsSetLong(vipKey, trainData.uuid)
        showVip = true
        if showDriver then
          key = "TRAIN_DRIVER_ANIM"
          CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
          showDriver = true
        end
      end
    end
    local key = "TRAIN_HAVE_SEEN"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainUuid ~= trainData.uuid then
      showTrainEnter = true
      if showDriver then
        key = "TRAIN_DRIVER_ANIM"
        CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
        showDriver = false
      end
      if showVip then
        key = "TRAIN_VIP_ANIM"
        CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
        showVip = false
      end
    end
  end
  if showDriver or showVip then
    self.curPage = TrainPreparePage.Driver
  end
  local z = self.curPage == TrainPreparePage.Passenger and minZ or maxZ
  self.controlCameraTrans:Set_localPosition(cameraX, cameraY, z)
  self.controlCameraTrans:Set_localEulerAngles(cameraRotX, 0, 0)
  self.controlCameraZ = z
  self:InitCamera()
  self:AddUpdateTimer()
  self.plane = Plane.New(Vector3.up, -SceneY)
  local carriage1 = sceneRoot:Find("train/weiyi/carriage1")
  local carriage2 = sceneRoot:Find("train/weiyi/carriage2")
  local carriage3 = sceneRoot:Find("train/weiyi/carriage3")
  local carriage4 = sceneRoot:Find("train/weiyi/carriage4")
  self.carriageList = {}
  table.insert(self.carriageList, carriage1)
  table.insert(self.carriageList, carriage2)
  table.insert(self.carriageList, carriage3)
  table.insert(self.carriageList, carriage4)
  self.trainRoot = sceneRoot:Find("train/weiyi")
  self.trainAnim = self.trainRoot:GetComponent(typeof(CS.UnityEngine.Animator))
  self.trainAnim.enabled = false
  self.driver = sceneRoot:Find("train/weiyi/driver")
  self.driverBubble = sceneRoot:Find("train/weiyi/driverBubble")
  local bubbleZ = self.curPage == TrainPreparePage.Passenger and driverBubbleOffsetFrom or driverBubbleOffsetTo
  self.driverBubble:Set_localPosition(0, 0, bubbleZ)
  self.tail = sceneRoot:Find("train/weiyi/tail")
  self.randomToggleRoot = sceneRoot:Find("randomToggleRoot")
  self.parkList = {}
  self.parkAnimList = {}
  self.parkSlotList = {}
  for i = 1, 3 do
    local park = sceneRoot:Find("park" .. i)
    if park then
      self.parkList[i] = park
      local slotList = {}
      for i = 1, ArmyFormationSlot.Dominator do
        local slot = park:Find("slot" .. i)
        table.insert(slotList, slot)
      end
      self.parkSlotList[i] = slotList
      local anim = park:GetComponent(typeof(CS.SimpleAnimation))
      table.insert(self.parkAnimList, anim)
    end
  end
  if self.inputManager == nil then
    self.inputManager = CS.CustomSceneInputManager()
    self.inputManager:Init(self.controlCamera)
  end
  self.coachRootList = {}
  for i = 1, 4 do
    local root = sceneRoot:Find("Coach" .. i)
    table.insert(self.coachRootList, root)
  end
  self.VIPRoot = sceneRoot:Find("Coach5")
  self:LoadTrain(true)
  self:LoadPassengers()
  self.showTrainEnter = showTrainEnter
  self.showDriver = showDriver
  self.showVip = showVip
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepareScene, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.trainPrepare)
  self:CheckShowTrainEnter(trainData)
end

function LWTrainPrepareSceneManager:CheckShowTrainEnter(trainData)
  if not self.showTrainEnter and not self.showDriver and not self.showVip then
    self.trainRoot:Set_localPosition(0, 0, trainRootAnimEndZ)
    self.trainAnim.enabled = false
    for i = 1, 3 do
      local anim = self.parkAnimList[i]
      if anim then
        anim:Rewind("Default")
        anim:Play("Default")
      end
    end
    self.passengersBubbleTimer = DataCenter.LWAllyStationDataManager:GetBubbleShowTimer()
    return
  end
  if self.showTrainEnter then
    for i = 1, 3 do
      local anim = self.parkAnimList[i]
      if anim then
        anim:Rewind("Default")
        anim:Play("Default")
      end
    end
    self.trainRoot:Set_localPosition(0, 0, trainRootAnimStartZ)
    self.controlCameraTrans:Set_localPosition(cameraX, cameraAnimStartY, cameraAnimStartZ)
    self.controlCameraTrans:Set_localEulerAngles(cameraAnimStartRotX, 0, 0)
    if self.forceEnter then
      self:TrainEnterImp()
    else
      self:DelayEnter(2)
    end
    return
  end
  if self.showDriver or self.showVip then
    self.trainRoot:Set_localPosition(0, 0, trainRootAnimEndZ)
    self.trainAnim.enabled = false
    self.passengersBubbleTimer = DataCenter.LWAllyStationDataManager:GetBubbleShowTimer()
    if self.showVip then
      if self.forceEnter then
        self:ShowDriverAnim(trainData, true)
      else
        self:DelayDriverAnim(2, true)
      end
      return
    end
    if self.forceEnter then
      self:ShowDriverAnim(trainData)
    else
      self:DelayDriverAnim(2)
    end
  end
end

function LWTrainPrepareSceneManager:DelayDriverAnim(delayTime, isVip)
  self:ClearDelayDriverAnim()
  if delayTime == nil then
    delayTime = 1.1
  end
  for i = 1, 3 do
    local anim = self.parkAnimList[i]
    if anim then
      anim:Stop()
      anim:SampleAnimationAtTime("Down", 0)
    end
  end
  self.delayDriverAnim = TimerManager:GetInstance():DelayInvoke(function()
    self.delayDriverAnim = nil
    self:ShowDriverAnim(nil, isVip)
    if isVip then
    else
      EventManager:GetInstance():Broadcast(EventId.TrainPrepareSceneDriverAnimStart)
    end
  end, delayTime)
end

function LWTrainPrepareSceneManager:ClearDelayDriverAnim()
  if self.delayDriverAnim then
    self.delayDriverAnim:Stop()
    self.delayDriverAnim = nil
  end
end

function LWTrainPrepareSceneManager:DelayEnter(delayTime)
  self:ClearDelayEnter()
  if delayTime == nil then
    delayTime = 1.1
  end
  self.delayEnter = TimerManager:GetInstance():DelayInvoke(function()
    self.delayEnter = nil
    self:TrainEnterImp()
  end, delayTime)
end

function LWTrainPrepareSceneManager:ClearDelayEnter()
  if self.delayEnter then
    self.delayEnter:Stop()
    self.delayEnter = nil
  end
end

function LWTrainPrepareSceneManager:TrainEnterImp()
  if not self.dataValid then
    return
  end
  self.trainAnim.enabled = true
  if self.cameraAnim ~= nil then
    self.cameraAnim.enabled = true
    self.cameraAnim:Rewind("Default")
    self.cameraAnim:Play("Default")
  end
  if self.trainEnterSound == nil then
    self.trainEnterSound = DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_arrive, false)
  end
  self:ClearTrainEnterFinishTimer()
  self.trainEnterFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.trainEnterFinishTimer = nil
    self:BreakTrainEnter()
    EventManager:GetInstance():Broadcast(EventId.TrainPrepareSceneEnterFinish)
  end, 6)
  self:LoadTrainEnterEffect()
end

function LWTrainPrepareSceneManager:BreakTrainEnter()
  if self.dataValid and self.showTrainEnter then
    self:ClearTrainEnterFinishTimer()
    self.trainRoot:Set_localPosition(0, 0, trainRootAnimEndZ)
    self.trainAnim.enabled = false
    if self.cameraAnim ~= nil then
      self.cameraAnim:Stop()
      self.cameraAnim.enabled = false
    end
    local z = self.curPage == TrainPreparePage.Passenger and minZ or maxZ
    self.controlCameraTrans:Set_localPosition(cameraX, cameraY, z)
    self.controlCameraTrans:Set_localEulerAngles(cameraRotX, 0, 0)
    self.controlCameraZ = z
    local bubbleZ = self.curPage == TrainPreparePage.Passenger and driverBubbleOffsetFrom or driverBubbleOffsetTo
    self.driverBubble:Set_localPosition(0, 0, bubbleZ)
    self:ClearTrainEnterEffect()
    self.showTrainEnter = false
    self.passengersBubbleTimer = DataCenter.LWAllyStationDataManager:GetBubbleShowTimer()
    self:CheckShowNewTrainInfo()
    if self.trainEnterSound ~= nil and 0 < self.trainEnterSound then
      DataCenter.LWSoundManager:StopSound(self.trainEnterSound)
      self.trainEnterSound = nil
    end
  end
end

function LWTrainPrepareSceneManager:CheckShowNewTrainInfo()
  local isNew = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
  if not isNew then
    return
  end
  local hasShow = Setting:GetPrivateBool(SettingKeys.NEW_TRAIN_INFO_SHOW, false)
  if hasShow then
    return
  end
  Setting:SetPrivateBool(SettingKeys.NEW_TRAIN_INFO_SHOW, true)
  RailwayUtil.ShowTrainActivityConstruction()
end

function LWTrainPrepareSceneManager:RefreshShowDriverAnim(trainData)
  if self.showDriver then
    return true, self.delayDriverAnim ~= nil and 2 or 0
  end
  if trainData == nil then
    return false
  end
  local showDriver = false
  if not string.IsNullOrEmpty(trainData.ownerId) then
    local key = "TRAIN_DRIVER_ANIM"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainData.uuid ~= trainUuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      showDriver = true
    end
  end
  self.showDriver = showDriver
  if showDriver then
    self:ShowDriverAnim(trainData)
  end
  return self.showDriver, 0
end

function LWTrainPrepareSceneManager:ShowDriverAnim(trainData, isVip)
  self:ClearDriverAnimTimer()
  if trainData == nil then
    trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  end
  if trainData == nil then
    return
  end
  if self.cameraShakeAnim then
    self.cameraShakeAnim.enabled = true
    self.cameraShakeAnim:SampleAnimationAtTime("Default", 0)
  end
  for i = 1, 3 do
    local anim = self.parkAnimList[i]
    if anim then
      anim:Stop()
      anim:SampleAnimationAtTime("Down", 0)
    end
  end
  self.curPage = TrainPreparePage.Driver
  local z = self.curPage == TrainPreparePage.Passenger and minZ or maxZ
  self.controlCameraTrans:Set_localPosition(cameraX, cameraY, z)
  self.controlCameraTrans:Set_localEulerAngles(cameraRotX, 0, 0)
  self.controlCameraZ = z
  local bubbleZ = self.curPage == TrainPreparePage.Passenger and driverBubbleOffsetFrom or driverBubbleOffsetTo
  self.driverBubble:Set_localPosition(0, 0, bubbleZ)
  local delayTimeVip = isVip and 0 or 3
  self:PlayDriverDropSequence(trainData, delayTimeVip)
end

function LWTrainPrepareSceneManager:PlayDriverDropSequence(trainData, delayTime)
  self.driverDropSequence = CS.DG.Tweening.DOTween.Sequence()
  self.driverDropSequence:AppendInterval(delayTime)
  for i = 1, 3 do
    local list = trainData.teamList[i]
    if list and list.heros and #list.heros > 0 then
      local anim = self.parkAnimList[i]
      if anim then
        self.driverDropSequence:AppendCallback(function()
          anim:Stop()
          anim:SampleAnimationAtTime("Down", 0)
          anim:Play("Down")
        end)
        self.driverDropSequence:AppendInterval(0.2)
        self.driverDropSequence:AppendCallback(function()
          if self.cameraShakeAnim then
            self.cameraShakeAnim:Rewind("Default")
            self.cameraShakeAnim:Play("Default")
          end
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.leader_troops_down, false)
        end)
        self.driverDropSequence:AppendInterval(0.1)
      end
    else
      local anim = self.parkAnimList[i]
      if anim then
        anim:Rewind("Default")
        anim:Play("Default")
      end
    end
  end
  self.driverAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:BreakDriverAnim()
  end, 5.2)
  EventManager:GetInstance():Broadcast(EventId.TrainPrepareScenePageChanged)
end

function LWTrainPrepareSceneManager:BreakDriverAnim()
  if self.dataValid and (self.showDriver or self.showVip) then
    self:ClearDriverAnimTimer()
    for i = 1, 3 do
      local anim = self.parkAnimList[i]
      if anim then
        anim:Rewind("Default")
        anim:Play("Default")
      end
    end
    if self.cameraShakeAnim then
      self.cameraShakeAnim:Stop()
      self.cameraShakeAnim:SampleAnimationAtTime("Default", 1)
      self.cameraShakeAnim.enabled = false
    end
    if self.showDriver then
      self.showDriver = false
    end
    if self.showVip then
      self.showVip = false
    end
  end
end

function LWTrainPrepareSceneManager:ClearDriverAnimTimer()
  if self.driverAnimTimer then
    self.driverAnimTimer:Stop()
    self.driverAnimTimer = nil
  end
  if self.driverDropSequence then
    self.driverDropSequence:Kill()
    self.driverDropAnimTimer = nil
  end
end

function LWTrainPrepareSceneManager:ClearTrainEnterFinishTimer()
  if self.trainEnterFinishTimer then
    self.trainEnterFinishTimer:Stop()
    self.trainEnterFinishTimer = nil
  end
end

function LWTrainPrepareSceneManager:LoadTrain(init)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return
  end
  self.trainReqs = {}
  local cfgId = trainData.cfgId
  self.cfgId = cfgId
  local ur = RailwayUtil.IsUR(cfgId)
  self.ur = ur
  local path = ur and CarriagePrefabPathUR or CarriagePrefabPath
  local driver = path[1]
  local offset = ur and CarriageOffsetUR or CarriageOffset
  local driverReq = Resource:InstantiateAsync(driver)
  table.insert(self.trainReqs, driverReq)
  driverReq:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.driver)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local offsetZ = offset[1] or 0
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, offsetZ)
  end)
  local p = path[2]
  for i = 1, 4 do
    local offsetZ = offset[i + 1]
    local req = Resource:InstantiateAsync(p)
    table.insert(self.trainReqs, req)
    req:completed("+", function(request)
      if not self.dataValid then
        request:Destroy()
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.carriageList[i])
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      trans:Set_localPosition(ResetPosition.x, ResetPosition.y, offsetZ)
    end)
  end
  local tail = path[1]
  local tailOffsetZ = offset[6] or 0
  local tailReq = Resource:InstantiateAsync(tail)
  table.insert(self.trainReqs, tailReq)
  tailReq:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.tail)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, tailOffsetZ)
  end)
  if not self.ur and init then
    self:PreloadURTrain()
  end
end

function LWTrainPrepareSceneManager:PreloadURTrain()
  self.preloadURTrainReqs = {}
  local path = CarriagePrefabPathUR
  local driver = path[1]
  local offset = CarriageOffsetUR
  local driverReq = Resource:InstantiateAsync(driver)
  table.insert(self.preloadURTrainReqs, driverReq)
  driverReq:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.driver)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local offsetZ = offset[1] or 0
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, offsetZ)
    go:SetActive(self.ur)
  end)
  local p = path[2]
  for i = 1, 4 do
    local offsetZ = offset[i + 1]
    local req = Resource:InstantiateAsync(p)
    table.insert(self.preloadURTrainReqs, req)
    req:completed("+", function(request)
      if not self.dataValid then
        request:Destroy()
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.carriageList[i])
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      trans:Set_localPosition(ResetPosition.x, ResetPosition.y, offsetZ)
      go:SetActive(self.ur)
    end)
  end
  local tail = path[1]
  local tailOffsetZ = offset[6] or 0
  local tailReq = Resource:InstantiateAsync(tail)
  table.insert(self.preloadURTrainReqs, tailReq)
  tailReq:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.tail)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, tailOffsetZ)
    go:SetActive(self.ur)
  end)
end

function LWTrainPrepareSceneManager:ReloadTrain()
  if not self.dataValid then
    return
  end
  self:UnloadTrain()
  self:LoadTrain()
end

function LWTrainPrepareSceneManager:UnloadTrain()
  if self.trainReqs then
    for _, v in ipairs(self.trainReqs) do
      v:Destroy()
    end
  end
  self.trainReqs = nil
end

function LWTrainPrepareSceneManager:UnloadPreloadTrain()
  if self.preloadURTrainReqs then
    for _, v in pairs(self.preloadURTrainReqs) do
      v:Destroy()
    end
  end
  self.preloadURTrainReqs = nil
end

function LWTrainPrepareSceneManager:LoadTrainEnterEffect()
  self:ClearTrainEnterEffect()
  self.trainEnterEffect = Resource:InstantiateAsync(TrainEnterEffect)
  self.trainEnterEffect:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.trainRoot)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end)
end

function LWTrainPrepareSceneManager:LoadTrainChangeEffect()
  self:ClearTrainChangeEffect()
  self.trainChangeEffect = Resource:InstantiateAsync(ChangeEffectPath2)
  self.trainChangeEffect:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.trainRoot)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    if self.reloadingTrain then
      go:SetActive(true)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_turn_gold2, false)
    else
      go:SetActive(false)
    end
  end)
end

function LWTrainPrepareSceneManager:LoadTrainChangeEffect2()
  self:ClearTrainChangeEffect2()
  self.trainChangeEffect2 = Resource:InstantiateAsync(ChangeEffectPath)
  self.trainChangeEffect2:completed("+", function(request)
    if not self.dataValid then
      request:Destroy()
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.trainRoot)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end)
end

function LWTrainPrepareSceneManager:ClearTrainEnterEffect()
  if self.trainEnterEffect then
    self.trainEnterEffect:Destroy()
    self.trainEnterEffect = nil
  end
end

function LWTrainPrepareSceneManager:ClearTrainChangeEffect()
  if self.trainChangeEffect then
    self.trainChangeEffect:Destroy()
    self.trainChangeEffect = nil
  end
end

function LWTrainPrepareSceneManager:ClearTrainChangeEffect2()
  if self.trainChangeEffect2 then
    self.trainChangeEffect2:Destroy()
    self.trainChangeEffect2 = nil
  end
end

function LWTrainPrepareSceneManager:DelayReloadTrain()
  self:ClearDelayReloadTrainSequence()
  self.delayReloadTrainSequence = CS.DG.Tweening.DOTween.Sequence()
  self.delayReloadTrainSequence:AppendInterval(2)
  self.delayReloadTrainSequence:AppendCallback(function()
    self.reloadingTrain = true
    if self.trainChangeEffect and IsNotNull(self.trainChangeEffect.gameObject) then
      self.trainChangeEffect.gameObject:SetActive(true)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_turn_gold2, false)
    end
  end)
  for i = 1, 6 do
    self.delayReloadTrainSequence:AppendInterval(0.1)
    self.delayReloadTrainSequence:AppendCallback(function()
      local req = self.preloadURTrainReqs[i]
      if req and not IsNull(req.gameObject) then
        req.gameObject:SetActive(true)
      end
      req = self.trainReqs[i]
      if req and not IsNull(req.gameObject) then
        req.gameObject:SetActive(false)
      end
    end)
  end
  self.delayReloadTrainSequence:AppendInterval(0.3)
  self.delayReloadTrainSequence:AppendCallback(function()
    self:LoadTrainChangeEffect2()
    self:UnloadTrain()
    self.reloadingTrain = false
  end)
end

function LWTrainPrepareSceneManager:ClearDelayReloadTrainSequence()
  if self.delayReloadTrainSequence then
    self.delayReloadTrainSequence:Kill()
    self.delayReloadTrainSequence = nil
  end
  self.reloadingTrain = false
end

function LWTrainPrepareSceneManager:LoadPassengers()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local platformState = platformData.state
  if platformState ~= TrainPlatformState.TrainWithDriver then
    return
  end
  local lineUp = platformData.lineUp
  local passengers = LWTrainPrepareScenePassengers.New(self.controlCamera, self.coachRootList[1], 1)
  passengers:RefreshPassengers(lineUp, false, trainData.name)
  self.passengers = passengers
end

function LWTrainPrepareSceneManager:UnloadPassengers()
  self:ClearDelayTimer()
  if self.passengers then
    self.passengers:Delete()
    self.passengers = nil
  end
  if self.vipPassenger then
    self.vipPassenger:Delete()
    self.vipPassenger = nil
  end
end

function LWTrainPrepareSceneManager:RefreshTrain(reloadImmediate)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return false
  end
  local playURTrainEffect = false
  local cfgId = trainData.cfgId
  if self.cfgId and self.cfgId ~= cfgId then
    if reloadImmediate then
      self.cfgId = cfgId
      self:ReloadTrain()
      return false
    end
    if RailwayUtil.IsUR(cfgId) and not self.showTrainEnter and not self.showDriver then
      self.cfgId = cfgId
      self:LoadTrainChangeEffect()
      self:DelayReloadTrain()
      playURTrainEffect = true
    else
      self:ReloadTrain()
    end
  end
  return playURTrainEffect
end

function LWTrainPrepareSceneManager:RefreshPassenger()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  local platformState = platformData.state
  if platformState ~= TrainPlatformState.TrainWithDriver then
    return
  end
  if self.passengers then
    local lineUp = platformData.lineUp
    self.passengers:RefreshPassengers(lineUp, true, trainData.name)
  else
    local passengers = LWTrainPrepareScenePassengers.New(self.controlCamera, self.coachRootList[1], 1)
    local lineUp = platformData.lineUp
    passengers:RefreshPassengers(lineUp, false, trainData.name)
    self.passengers = passengers
  end
end

function LWTrainPrepareSceneManager:RefreshVIPPassenger(isMy, vipId)
  if self.vipPassenger then
    return
  end
  local passengers = LWTrainPrepareScenePassengers.New(self.controlCamera)
  passengers:InitVIPPassenger(self.VIPRoot, vipId)
  self.vipPassenger = passengers
  if isMy then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TrainVIPShowBubble("vip", self.VIPRoot, vipId)
    end, 2)
  end
end

function LWTrainPrepareSceneManager:TrainVIPShowBubble(bUuid, root, vipId)
  function self.OnClickCallBack()
    EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipRewardSelectHide)
  end
  
  if self.VIPBubble then
    self.VIPBubble:OnDestroy()
    self.VIPBubble = nil
  end
  local param = {
    iconName = "Assets/Main/Sprites/UI/UIPersonalArms/cfm_huodong_gerenjunbei_baoxiang_xiao_5.png",
    bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Bubble_Bg1),
    model = UIAssets.BuildStateIcon,
    buildBubbleType = BuildBubbleType.TrainVIP,
    pos = nil,
    tileX = 1,
    tileY = 1,
    callBack = self.OnClickCallBack,
    uuid = vipId,
    bgScale = Vector3.New(1, 1, 1),
    iconScale = Vector3.New(2.5, 2.5, 2.5),
    buildId = bUuid,
    dontShake = false
  }
  local request = CS.GameEntry.Resource:InstantiateAsync(param.model)
  param.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(root)
    request.gameObject.transform:Set_localScale(1, 1, 1)
    request.gameObject.transform:Set_localPosition(0.78, 6, 0.52)
    request.gameObject.name = "BuildBubble" .. bUuid
    local buildBubbleTip = BuildBubbleTip.New()
    buildBubbleTip:OnCreate(request)
    buildBubbleTip:ReInit(param)
    self.VIPBubble = buildBubbleTip
    local rotation = Quaternion.Euler(90, -90, 0)
    request.gameObject.transform:Set_localRotation(rotation.x, rotation.y, rotation.z, rotation.w)
    self.VIPBubble:Show()
    local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    local platformState = platformData.state
    if platformState == TrainPlatformState.TrainWithPassenger then
      self.VIPBubble:Hide()
      self.VIPBubble.gameObject:SetActive(false)
      return
    end
    if self.curPage == TrainPreparePage.Driver then
      self.VIPBubble:Hide()
      self.VIPBubble.gameObject:SetActive(false)
    end
  end)
end

function LWTrainPrepareSceneManager:RefreshBubbleTip(curPage)
  if self.VIPBubble then
    local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    local platformState = platformData.state
    if platformState == TrainPlatformState.TrainWithPassenger then
      self.VIPBubble:Hide()
      self.VIPBubble.gameObject:SetActive(false)
      return
    end
    if curPage ~= TrainPreparePage.Driver then
      self.VIPBubble.gameObject:SetActive(true)
      self.VIPBubble:Show()
    else
      self.VIPBubble:Hide()
    end
  end
end

function LWTrainPrepareSceneManager:ClearDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function LWTrainPrepareSceneManager:InitCamera()
  local camera = self.controlCamera
  self.touchCamera = camera:GetComponent(typeof(MobileTouchCamera))
  self.touchCamera.CanMoveing = false
  local touchInput = self.touchCamera.touchInput
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
  self.fingerDown = false
end

function LWTrainPrepareSceneManager:UnloadScene()
  self:UnloadPassengers()
  self:UnloadTrain()
  self:UnloadPreloadTrain()
  self.carriageList = nil
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
  self:UnInitCamera()
end

function LWTrainPrepareSceneManager:UnInitCamera()
  if self.touchCamera and self.touchCamera.touchInput then
    local touchInput = self.touchCamera.touchInput
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
    self.touchCamera = nil
  end
end

function LWTrainPrepareSceneManager:OnFingerDown(pos)
  if CS.CSUtils.IsPointerOverUIObject() then
    return
  end
  if self.showTrainEnter or self.showDriver then
    return
  end
  local ray = self.controlCamera:ScreenPointToRay(pos)
  local _, dis = self.plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  self.lastFingerPosZ = hitPoint.z
  self.fingerDownCameraZ = self.controlCameraZ
  self.fingerDown = true
  self.hasBroadcastBeginMove = false
end

function LWTrainPrepareSceneManager:OnFingerUp()
  if not self.fingerDown then
    return
  end
  self.fingerDown = false
  self.moveTime = 0
  if Mathf.Abs(self.fingerDownCameraZ - minZ) < 0.5 then
    if 0.5 < self.controlCameraZ - self.fingerDownCameraZ then
      self.moveTargetZ = maxZ
    else
      self.moveTargetZ = minZ
    end
  elseif 0.5 < self.fingerDownCameraZ - self.controlCameraZ then
    self.moveTargetZ = minZ
  else
    self.moveTargetZ = maxZ
  end
end

function LWTrainPrepareSceneManager:OnUpdate()
  if self.inputManager then
    self.inputManager:OnUpdate()
  end
  self:UpdatePassengersBubble()
  if not self.fingerDown then
    self:UpdateMove()
    return
  end
  local pos
  if Touch.TouchCount > 0 then
    local touch = Touch.Touches[0]
    pos = touch.Position
  end
  if not pos then
    return
  end
  local ray = self.controlCamera:ScreenPointToRay(pos)
  local _, dis = self.plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  local delta = hitPoint.z - self.lastFingerPosZ
  if math.abs(delta) < DISPLACE_EPSILON then
    return
  end
  local newZ = self.controlCameraZ - delta
  newZ = Mathf.Clamp(newZ, minZ, maxZ)
  if not self.hasBroadcastBeginMove then
    self.hasBroadcastBeginMove = true
    EventManager:GetInstance():Broadcast(EventId.TrainPrepareScenePageBeginMove)
  end
  self.controlCameraZ = newZ
  self.controlCameraTrans:Set_localPosition(cameraX, cameraY, newZ)
  local p = (newZ - minZ) / (maxZ - minZ)
  local driverBubbleZ = Mathf.Lerp(driverBubbleOffsetFrom, driverBubbleOffsetTo, p)
  self.driverBubble:Set_localPosition(0, 0, driverBubbleZ)
end

function LWTrainPrepareSceneManager:UpdateMove()
  if self.moveTime == nil then
    return
  end
  self.moveTime = self.moveTime + Time.deltaTime
  local smooth = 4
  local t = self.moveTime * smooth
  local lerpZ = Mathf.Lerp(self.controlCameraZ, self.moveTargetZ, t)
  self.controlCameraZ = lerpZ
  self.controlCameraTrans:Set_localPosition(cameraX, cameraY, lerpZ)
  local p = (lerpZ - minZ) / (maxZ - minZ)
  local driverBubbleZ = Mathf.Lerp(driverBubbleOffsetFrom, driverBubbleOffsetTo, p)
  self.driverBubble:Set_localPosition(0, 0, driverBubbleZ)
  if 1 <= t then
    self.moveTime = nil
    if Mathf.Abs(self.moveTargetZ - minZ) < 0.1 then
      self.curPage = TrainPreparePage.Passenger
    else
      self.curPage = TrainPreparePage.Driver
    end
    EventManager:GetInstance():Broadcast(EventId.TrainPrepareScenePageChanged)
  end
end

function LWTrainPrepareSceneManager:MoveToFront()
  if not self.sceneLoaded then
    return
  end
  if not self.dataValid then
    return
  end
  if self.moveTime ~= nil then
    return
  end
  self.moveTime = 0
  self.moveTargetZ = maxZ
end

function LWTrainPrepareSceneManager:MoveToBack()
  if not self.sceneLoaded then
    return
  end
  if not self.dataValid then
    return
  end
  if self.moveTime ~= nil then
    return
  end
  self.moveTime = 0
  self.moveTargetZ = minZ
end

function LWTrainPrepareSceneManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function LWTrainPrepareSceneManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function LWTrainPrepareSceneManager:GetPark(index)
  if self.parkList then
    return self.parkList[index]
  end
  return nil
end

function LWTrainPrepareSceneManager:GetParkSlotList(index)
  if self.parkSlotList then
    return self.parkSlotList[index]
  end
  return nil
end

function LWTrainPrepareSceneManager:UpdatePassengersBubble()
  if self.passengersBubbleTimer == nil then
    return
  end
  if self.passengersBubbleTimer > 0 then
    self.passengersBubbleTimer = self.passengersBubbleTimer - Time.deltaTime
    if self.passengersBubbleTimer <= 0 then
      self.passengersBubbleTimer = DataCenter.LWAllyStationDataManager:GetBubbleShowTimer()
      if self.passengers then
        self.passengers:RandomBubble()
      end
    end
  end
end

function LWTrainPrepareSceneManager:SetAcceptVipValue(value)
  self.acceptVip = value
  self:GetAcceptVipValue()
end

function LWTrainPrepareSceneManager:SetAcceptVipInfoValue(value)
  self.acceptVipInfo = value
  self:GetAcceptVipValue()
end

function LWTrainPrepareSceneManager:GetAcceptVipValue()
  if self.acceptVip and self.acceptVipInfo then
    EventManager:GetInstance():Broadcast(EventId.AllianceTrainVipSetInfo)
    self.acceptVip = false
    self.acceptVipInfo = false
  end
end

return LWTrainPrepareSceneManager
