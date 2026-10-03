local T11IdleGameIdleBattleLogic = BaseClass("T11IdleGameIdleBattleLogic")
local FSMachine = require("Common.FSMachine")
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local InitState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStateInit")
local LoadState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStateLoad")
local OpeningState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStateOpening")
local GoingState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStateGoing")
local PlayNodeState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStatePlayNode")
local EndState = require("DataCenter/T11IdleGame/IdleBattle/Battle/State/T11IdleGameBattleStateEnd")
local T11IdleGameIdleBattleNodeManager = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNodeManager")
local T11IdleGameIdleBattleSquad = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleSquad")
local T11IdleGameIdleBattleSceneManager = require("DataCenter/T11IdleGame/IdleBattle/Battle/Scene/T11IdleGameIdleBattleSceneManager")

function T11IdleGameIdleBattleLogic:__init()
  self.param = nil
  self.sceneRootReq = nil
  self.sceneCamera = nil
  self.sceneRoot = nil
  self.soldierRoot = nil
  self.chestRoot = nil
  self.battleRoot = nil
  self.eventRoot = nil
  self.bgRoot = nil
  self.virtualCameraIdle = nil
  self.virtualCameraChest = nil
  self.renderTexture = nil
  self.nodeManager = nil
  self.squad = nil
  self.sceneManager = nil
  self.mainView = nil
  self.battleUIComponent = nil
end

function T11IdleGameIdleBattleLogic:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleLogic:Enter(param)
  self.param = param
  self.nodeManager = nil
  self.sceneManager = nil
  self.mainView = nil
  self.curState = Const.State.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.State.Init, InitState.Create())
  self.fsm:Add(Const.State.Load, LoadState.Create())
  self.fsm:Add(Const.State.Opening, OpeningState.Create())
  self.fsm:Add(Const.State.Going, GoingState.Create())
  self.fsm:Add(Const.State.PlayNode, PlayNodeState.Create())
  self.fsm:Add(Const.State.End, EndState.Create())
  self:OnEnterGame()
  DataCenter.CityLightManager:AddDeactiveRef()
  self:AddUpdateTimer()
  self:AddListener(EventId.T11IdleGameOnRewardUpdateMessage, self.OnRewardUpdateSuccess)
  self:AddListener(EventId.T11IdleGameOnGetIdleGameMainMessage, self.OnGetMainDataSuccess)
end

function T11IdleGameIdleBattleLogic:Destroy()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.nodeManager then
    self.nodeManager:Destroy()
    self.nodeManager = nil
  end
  if self.squad then
    self.squad:Destroy()
    self.squad = nil
  end
  if self.sceneManager then
    self.sceneManager:Destroy()
    self.sceneManager = nil
  end
  self:DestroyRenderTexture()
  self:DestroySceneRoot()
  self.sceneCamera = nil
  self.sceneRoot = nil
  self.soldierRoot = nil
  self.chestRoot = nil
  self.battleRoot = nil
  self.eventRoot = nil
  self.bgRoot = nil
  self.virtualCameraIdle = nil
  self.virtualCameraChest = nil
  self.renderTexture = nil
  self.mainView = nil
  self.battleUIComponent = nil
  self.param = nil
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:RemoveAllListeners()
end

function T11IdleGameIdleBattleLogic:OnUpdate()
  local dt = Time.deltaTime
  if self.fsm then
    self.fsm:Update(dt)
  end
  if self.nodeManager then
    self.nodeManager:OnUpdate(dt)
  end
  if self.squad then
    self.squad:OnUpdate(dt)
  end
  if self.sceneManager then
    self.sceneManager:OnUpdate(dt)
  end
end

function T11IdleGameIdleBattleLogic:OnUpdate1000MS()
  if self.fsm then
    local curState = self.fsm:GetCurState()
    if curState and curState.OnUpdate1000MS then
      curState:OnUpdate1000MS()
    end
  end
end

function T11IdleGameIdleBattleLogic:OnUpdate100MS()
  if self.fsm then
    local curState = self.fsm:GetCurState()
    if curState and curState.OnUpdate100MS then
      curState:OnUpdate100MS()
    end
  end
end

function T11IdleGameIdleBattleLogic:OnEnterGame()
  self:ChangeState(Const.State.Init)
end

function T11IdleGameIdleBattleLogic:OnInitFinish()
  self:SetSceneCameraActive(true)
  self:ChangeState(Const.State.Load)
  self:SetVirtualCameraState(Const.VirtualCameraState.Idle)
end

function T11IdleGameIdleBattleLogic:OnLoadFinish()
  local infoData = self:GetInfoData()
  if infoData == nil then
    return
  end
  if infoData:IsCanEnd() then
    self:ChangeState(Const.State.End)
  elseif self.param.isFromStart then
    self:ChangeState(Const.State.Opening)
  elseif self.param.needWaitForGetMainData and infoData:IsFutureNodeDataExpired() then
  else
    self:ChangeState(Const.State.Going, {
      preState = Const.State.Load
    })
  end
end

function T11IdleGameIdleBattleLogic:OnFinalNodeFinish()
  self:ChangeState(Const.State.End)
  self:ShowBattleUIEnd()
end

function T11IdleGameIdleBattleLogic:OnGetMainDataSuccess()
  self:OnLoadFinish()
end

function T11IdleGameIdleBattleLogic:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameIdleBattleLogic:ChangeState " .. state)
  self.curState = state
  self.fsm:Switch(state, ...)
end

function T11IdleGameIdleBattleLogic:CreateSceneRoot(callback)
  if self.sceneRootReq ~= nil then
    if not IsNull(self.sceneRootReq.gameObject) and callback then
      callback()
    else
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(Const.SceneRootAssetPath)
  self.sceneRootReq = request
  self.sceneRootReq:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(Const.DefaultSceneRootPos.x, Const.DefaultSceneRootPos.y, Const.DefaultSceneRootPos.z)
    self.sceneRoot = request.gameObject
    self.soldierRoot = request.gameObject.transform:Find("Squad").gameObject
    self.chestRoot = request.gameObject.transform:Find("Chest").gameObject
    self.battleRoot = request.gameObject.transform:Find("Battle").gameObject
    self.eventRoot = request.gameObject.transform:Find("Event").gameObject
    self.bgRoot = request.gameObject.transform:Find("BgRoot").gameObject
    self.virtualCameraIdle = request.gameObject.transform:Find("xingjun_cam").gameObject
    self.virtualCameraChest = request.gameObject.transform:Find("kaibaoxiang_cam").gameObject
    local cameraTrans = request.gameObject.transform:Find("Camera")
    if not IsNull(cameraTrans) then
      local camera = cameraTrans:GetComponentInChildren(typeof(Camera), true)
      self.sceneCamera = camera
    end
    if callback then
      callback()
    end
  end)
end

function T11IdleGameIdleBattleLogic:DestroySceneRoot()
  if self.sceneRootReq ~= nil then
    self.sceneRootReq:Destroy()
  end
  self.sceneRootReq = nil
end

function T11IdleGameIdleBattleLogic:SetSceneCameraActive(isActive)
  local sceneCamera = self.sceneCamera
  if IsNotNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(isActive)
    if isActive then
      self:SetRenderTexture()
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function T11IdleGameIdleBattleLogic:SetRenderTexture()
  if IsNull(self.sceneCamera) or self.param == nil then
    return
  end
  if self.renderTexture == nil then
    local rtWidth = math.floor(self.param.rtWidth)
    local rtHeight = math.floor(self.param.rtHeight)
    local rtFormat = RenderTextureFormat.ARGB32
    if CS.UnityEngine.SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf) then
      rtFormat = RenderTextureFormat.ARGBHalf
    end
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "T11IdleGameTexture" .. rtWidth .. "*" .. rtHeight
  end
  if self.param and self.param.renderTexture then
    self.param.renderTexture:SetTexture(self.renderTexture)
    self.param.renderTexture:SetEnable(true)
    self.param.renderTexture:SetColor(Color.New(1, 1, 1, 1))
  end
  self.sceneCamera.targetTexture = self.renderTexture
end

function T11IdleGameIdleBattleLogic:DestroyRenderTexture()
  if IsNotNull(self.sceneCamera) then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function T11IdleGameIdleBattleLogic:GetCameraInfo()
  if IsNull(self.sceneCamera) then
    return nil
  end
  local cameraHeight = self.sceneCamera.orthographicSize * 2
  local cameraWidth = cameraHeight * self.sceneCamera.aspect
  local centerPos = self.sceneCamera.transform.position
  return centerPos, cameraWidth, cameraHeight
end

function T11IdleGameIdleBattleLogic:SetVirtualCameraState(state)
  if IsNotNull(self.virtualCameraIdle) then
    self.virtualCameraIdle:SetActive(state == Const.VirtualCameraState.Idle)
  end
  if IsNotNull(self.virtualCameraChest) then
    self.virtualCameraChest:SetActive(state == Const.VirtualCameraState.Chest)
  end
end

function T11IdleGameIdleBattleLogic:CreateSceneManager(finishCallback)
  if IsNull(self.bgRoot) then
    return
  end
  self.sceneManager = T11IdleGameIdleBattleSceneManager.New(self)
  self.sceneManager:Init(self.bgRoot, finishCallback)
end

function T11IdleGameIdleBattleLogic:StartSceneManager()
  if self.sceneManager then
    self.sceneManager:Start()
  end
end

function T11IdleGameIdleBattleLogic:PauseSceneManager()
  if self.sceneManager then
    self.sceneManager:Pause()
  end
end

function T11IdleGameIdleBattleLogic:ResumeSceneManager()
  if self.sceneManager then
    self.sceneManager:Resume()
  end
end

function T11IdleGameIdleBattleLogic:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.update1000MSTimer == nil then
    self.update1000MSTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdate1000MS, self, false, false, false)
    self.update1000MSTimer:Start()
  end
  if self.update100MSTimer == nil then
    self.update100MSTimer = TimerManager:GetInstance():GetTimer(0.1, self.OnUpdate100MS, self, false, false, false)
    self.update100MSTimer:Start()
  end
end

function T11IdleGameIdleBattleLogic:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.update1000MSTimer then
    self.update1000MSTimer:Stop()
    self.update1000MSTimer = nil
  end
  if self.update100MSTimer then
    self.update100MSTimer:Stop()
    self.update100MSTimer = nil
  end
end

function T11IdleGameIdleBattleLogic:AddListener(msg_name, callback)
  if not self.__event_handlers then
    self.__event_handlers = {}
  end
  
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function T11IdleGameIdleBattleLogic:RemoveAllListeners()
  if not self.__event_handlers then
    return
  end
  for name, bindFunc in pairs(self.__event_handlers) do
    if bindFunc then
      EventManager:GetInstance():RemoveListener(name, bindFunc)
    end
  end
  self.__event_handlers = nil
end

function T11IdleGameIdleBattleLogic:GetInfoData()
  if self.param then
    return self.param.infoData
  end
end

function T11IdleGameIdleBattleLogic:GetNodeDataByIndex(nodeIndex)
  local infoData = self:GetInfoData()
  if infoData then
    return infoData:GetNodeDataByIndex(nodeIndex)
  end
end

function T11IdleGameIdleBattleLogic:TryTriggerNode(nodeData)
  if self.nodeManager == nil then
    self.nodeManager = T11IdleGameIdleBattleNodeManager.New(self)
  end
  if not self.nodeManager:IsCanTrigger(nodeData) then
    return false
  end
  self.nodeManager:TriggerNode(nodeData)
end

function T11IdleGameIdleBattleLogic:OnRewardUpdateSuccess(evtData)
  local info = self:GetInfoData()
  if not info then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleLogic:OnRewardUpdateSuccess call with nil data")
    return
  end
  if not info:IsHasStarted() then
    self:OnFinalNodeFinish()
    return
  end
  local nodeData = info:GetPassedNodeData()
  if not nodeData then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleLogic:OnRewardUpdateSuccess call with nil nodeData")
    return
  end
  if self.nodeManager == nil then
    DataCenter.T11IdleGameManager:PrintRealInfoLog("T11IdleGameIdleBattleLogic:OnRewardUpdateSuccess node is nil")
    return
  end
  if self.nodeManager:OnRewardUpdate(nodeData) == true then
    self:ChangeState(Const.State.PlayNode)
  end
end

function T11IdleGameIdleBattleLogic:GetNodePropRootByNodeType(type)
  if type == Const.NodeType.Chest then
    return self.chestRoot
  elseif type == Const.NodeType.Battle then
    return self.battleRoot
  elseif type == Const.NodeType.Event then
    return self.eventRoot
  end
end

function T11IdleGameIdleBattleLogic:OnNodePlayFinish(nodeData)
  local infoData = self:GetInfoData()
  if infoData == nil then
    return
  end
  if infoData:IsCanEnd() then
    self:OnFinalNodeFinish()
  else
    self:ChangeState(Const.State.Going, {
      preState = Const.State.PlayNode
    })
  end
  self:SetVirtualCameraState(Const.VirtualCameraState.Idle)
end

function T11IdleGameIdleBattleLogic:IsPlayingNode()
  if self.fsm then
    local curState = self.fsm:GetCurStateName()
    return curState == Const.State.PlayNode
  end
  return false
end

function T11IdleGameIdleBattleLogic:CreateSquad(finishCallback)
  if IsNull(self.soldierRoot) then
    return
  end
  self.squad = T11IdleGameIdleBattleSquad.New(self)
  self.squad:LoadSoldiers(self.soldierRoot, finishCallback)
end

function T11IdleGameIdleBattleLogic:ChangeSquadState(state, ...)
  if self.squad then
    self.squad:ChangeSoldiersState(state, ...)
  end
end

function T11IdleGameIdleBattleLogic:ChangeSingleSoldierState(index, state, ...)
  if self.squad then
    self.squad:ChangeSingleSoldierState(index, state, ...)
  end
end

function T11IdleGameIdleBattleLogic:GetSoldier(index)
  if self.squad then
    return self.squad:GetSoldier(index)
  end
  return nil
end

function T11IdleGameIdleBattleLogic:GetSquad()
  return self.squad
end

function T11IdleGameIdleBattleLogic:GetBattleMainView()
  if self.mainView == nil then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWT11IdleGameBattleMain)
    if window then
      self.mainView = window.View
    end
  end
  return self.mainView
end

function T11IdleGameIdleBattleLogic:GetBattleUIComponent()
  if self.battleUIComponent == nil then
    local mainView = self:GetBattleMainView()
    if mainView then
      self.battleUIComponent = mainView:GetBattleComponent()
    end
  end
  return self.battleUIComponent
end

function T11IdleGameIdleBattleLogic:ShowBattleUIEnd()
  local comp = self:GetBattleUIComponent()
  if comp then
    comp:OnGameEnd()
  end
end

return T11IdleGameIdleBattleLogic
