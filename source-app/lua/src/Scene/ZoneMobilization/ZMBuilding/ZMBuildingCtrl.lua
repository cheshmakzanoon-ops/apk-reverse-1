local ZMBuildingCtrl = BaseClass("ZMBuildingCtrl")
local FSM = require("Framework.Common.FSM")
local BornState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingBornState")
local BuildState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingBuildState")
local FlyawayState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingFlyawayState")
local IdleState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingIdleState")
local TransmittingState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingTransmittingState")
local RecycleState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingRecycleState")
local UpgradeState = require("Scene.ZoneMobilization.ZMBuilding.ZMBuildingUpgradeState")
local Worker = require("Scene.ZoneMobilization.ZMBuildingWorker.ZMBuildingWorker")
local worldModelPath = "Model/WorldModel"
local gua_dian_path = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root/GuaDian"
ZMBuildingCtrl.State = {
  Born = 1,
  Flyaway = 2,
  Recycle = 3,
  Transmitting = 4,
  Upgrade = 5,
  Build = 6,
  Idle = 7
}
ZMBuildingCtrl.Anim = {
  Born = "born",
  Idle = "idle",
  Recycle = "recycle"
}
ZMBuildingCtrl.EffectFlag = {
  Flyaway = 1,
  Upgrade = 2,
  IdleLight = 3,
  IdleFire = 4,
  Transmitting = 5
}
local Anim = ZMBuildingCtrl.Anim
local State = ZMBuildingCtrl.State
local EffectFlag = ZMBuildingCtrl.EffectFlag
local EffectPath = {
  [EffectFlag.Flyaway] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_chuansong_shangsheng_%s.prefab",
  [EffectFlag.Upgrade] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_shengji.prefab",
  [EffectFlag.IdleLight] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_deng.prefab",
  [EffectFlag.IdleFire] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_longmendiao_huohua.prefab",
  [EffectFlag.Transmitting] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_chuansong_loop_up_%s.prefab"
}
local EffectRootPath1 = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root"
local EffectRootPath2 = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root"
local workerPosList = {
  Vector3.New(-6.37, 0, 4.57),
  Vector3.New(-8.71, 0, 2.09),
  Vector3.New(-9.39, 0, -1.81),
  Vector3.New(-6.59, 0, -5.46),
  Vector3.New(-2.79, 0, -8.95),
  Vector3.New(2.58, 0, -8.82),
  Vector3.New(6.14, 0, -3.53),
  Vector3.New(8.54, 0, -0.6),
  Vector3.New(6.28, 0, 2.58)
}
local MAX_NUM = 9

function ZMBuildingCtrl:__init(uuid, transform, markCreat)
  self.uuid = uuid
  self.transform = transform
  self.markCreat = markCreat
  self.currStateIndex = nil
  self.oldPointInfo = nil
  self.suffix = nil
  self.modelNode = nil
  self.nodeGos = {}
  self.subNode = nil
  self.worldModel = nil
  self.simpleAnimation = nil
  self.showNodePath = nil
  self.allEffect = {}
  self.workers = {}
  self.buildPlayers = {}
  self.index = 0
  self.exitTime = 0
  self.worker = nil
  self.constExitTime = LuaEntry.DataConfig:TryGetNum("zone_mobilization_donate", "k14", 0)
  self:InitModelData(transform)
  self:InitFsm()
  self:InitState()
end

function ZMBuildingCtrl:__delete()
  self:Destroy()
end

local function Destroy(self)
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  self:ClearWorkers()
  self:ClearEffect()
  self:ResetNode()
  self.uuid = nil
  self.markCreat = nil
  self.currStateIndex = nil
  self.oldPointInfo = nil
  self.suffix = nil
  self.nodeGos = nil
  self.modelNode = nil
  self.subNode = nil
  self.worldModel = nil
  self.simpleAnimation = nil
  self.showNodePath = nil
  self.transform = nil
  self.index = nil
  self.exitTime = nil
  self.workers = nil
  self.buildPlayers = nil
  self.constExitTime = nil
end

local function ResetNode(self)
  if self.subNode then
    self.subNode:SetActive(false)
    self.subNode = nil
  end
  if self.modelNode then
    self.modelNode:SetActive(false)
    self.modelNode = nil
  end
  self.buildingAnim = nil
end

local function Refresh(self, uuid, transform)
  self.uuid = uuid
  self.transform = transform
  self:InitModelData(transform)
  self:InitState()
end

local function InitModelData(self, transform)
  if IsNull(transform) then
    return
  end
  self.worldModel = transform:Find(worldModelPath)
  if self.uuid and CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info then
      self.oldPointInfo = info
      local isSelf = info.serverId == LuaEntry.Player:GetSourceServerId()
      self.suffix = isSelf and "blue" or "red"
    end
  end
end

local function InitFsm(self)
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, IdleState.New(self))
  self.fsm:AddState(State.Born, BornState.New(self))
  self.fsm:AddState(State.Flyaway, FlyawayState.New(self))
  self.fsm:AddState(State.Transmitting, TransmittingState.New(self))
  self.fsm:AddState(State.Recycle, RecycleState.New(self))
  self.fsm:AddState(State.Upgrade, UpgradeState.New(self))
  self.fsm:AddState(State.Build, BuildState.New(self))
end

local function OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.exitTime and self.exitTime > 0 then
    self.exitTime = self.exitTime - deltaTime
    if self.exitTime <= 0 then
      self:ChangeState(State.Idle)
    end
  end
end

local function InitState(self)
  self:ChangeModel()
  if self.oldPointInfo then
    if self.markCreat and self.markCreat == 0 then
      self.markCreat = nil
      self:ChangeToBornState()
    else
      self:TryChangeCurState(self.oldPointInfo)
    end
  end
end

local function ChangeModel(self)
  local showModelData = self:GetShowModelData()
  if self.showNodePath == showModelData then
    return
  end
  self:ResetNode()
  if not string.IsNullOrEmpty(showModelData) then
    local nodeArr = string.split(showModelData, ",")
    if 1 < #nodeArr then
      local nodePath = nodeArr[1]
      nodePath = string.format(nodePath, self.suffix)
      local go = self.nodeGos[nodePath]
      if IsNull(go) then
        local node = self.worldModel:Find(nodePath)
        if not IsNull(node) then
          go = node.gameObject
          go:SetActive(true)
          self.nodeGos[nodePath] = go
        end
        self.modelNode = node and node.gameObject
      else
        go:SetActive(true)
        self.modelNode = go
      end
      if not IsNull(self.modelNode) then
        local str = string.format(nodeArr[2], self.suffix)
        local subGo = self.nodeGos[str]
        if IsNull(subGo) then
          local node = self.modelNode.transform
          local subNode = node:Find(gua_dian_path .. "/" .. str)
          if subNode then
            subGo = subNode.gameObject
            subGo:SetActive(true)
            self.nodeGos[str] = subGo
          end
          self.subNode = subNode and subNode.gameObject
        else
          subGo:SetActive(true)
          self.subNode = subGo
        end
      end
    else
      if self.subNode then
        self.subNode:SetActive(false)
        self.subNode = nil
      end
      local nodeName = string.format(nodeArr[1], self.suffix)
      local go = self.nodeGos[nodeName]
      if IsNull(go) then
        local node = self.worldModel:Find(nodeName)
        if node then
          go = node.gameObject
          go:SetActive(true)
          self.nodeGos[nodeName] = go
        end
        self.modelNode = node and node.gameObject
      else
        go:SetActive(true)
        self.modelNode = go
      end
    end
  end
  self.showNodePath = showModelData
  self.simpleAnimation = self.modelNode and self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
end

local function GetShowModelData(self)
  if self.uuid and CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if info and info.zoneMobilizationPointInfo then
      local modelData = GetTableData(TableName.ZoneMobilizationStage, info.zoneMobilizationPointInfo.stage, "world_model_3d")
      if not string.IsNullOrEmpty(modelData) then
        local pathArr = string.split(modelData, "|")
        if 1 < #pathArr then
          local index = info.zoneMobilizationPointInfo.donateMax and 2 or 1
          return pathArr[index]
        else
          return pathArr[1]
        end
      end
    end
  end
end

local function ChangeState(self, state, ...)
  if self.fsm then
    if self.currStateIndex == state then
      return
    end
    self.currStateIndex = state
    self.fsm:ChangeState(state, ...)
  end
end

local function PlayAnimation(self, animName, callback)
  if self.simpleAnimation == nil then
    return
  end
  if string.IsNullOrEmpty(animName) then
    animName = Anim.Idle
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if callback then
    local length = self.simpleAnimation:GetClipLength(animName)
    if 0 < length then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        if self.timer then
          self.timer:Stop()
          self.timer = nil
        end
      end, length)
    else
      callback()
    end
  end
  if self.simpleAnimation:IsPlaying(animName) then
    self.simpleAnimation:Rewind(animName)
  end
  self.simpleAnimation:Play(animName)
end

local function EnterWorld(self)
  self:InitFsm()
end

local function ExitWorld(self)
  self:Destroy()
end

local function TryChangeCurState(self, newPointInfo, oldPointInfo)
  if newPointInfo then
    if oldPointInfo == nil then
      local newInfo = newPointInfo.zoneMobilizationPointInfo
      if newInfo then
        local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(newInfo.stage)
        if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
          if self.currStateIndex and self.currStateIndex < State.Idle then
            return
          end
          self:ChangeState(State.Idle)
        elseif stageType == ZoneMobilizationStageType.Battle_Transfer then
          self:ChangeState(State.Transmitting)
        end
      end
    else
      local newInfo = newPointInfo.zoneMobilizationPointInfo
      if newInfo then
        local oldInfo = oldPointInfo and oldPointInfo.zoneMobilizationPointInfo
        local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(newInfo.stage)
        if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
          if oldInfo and oldInfo.stage < newInfo.stage then
            self:ChangeState(State.Upgrade)
          end
        elseif stageType == ZoneMobilizationStageType.Battle_Transfer then
          local oldStageType = DataCenter.LWZoneMobilizationManager:GetStageType(oldInfo and oldInfo.stage)
          local newStageType = DataCenter.LWZoneMobilizationManager:GetStageType(newInfo.stage)
          if oldStageType == ZoneMobilizationStageType.Battle_Place and newStageType == ZoneMobilizationStageType.Battle_Transfer then
            self:ChangeState(State.Recycle)
          else
            self:ChangeState(State.Transmitting)
          end
        end
      end
    end
  end
  if self.currStateIndex and self.currStateIndex < State.Idle then
    return
  end
  self:ChangeState(State.Idle)
end

local function ChangeToBornState(self)
  self:ChangeState(State.Born)
end

local function ChangeToIdleState(self)
  self:ChangeModel()
  self:ChangeState(State.Idle)
end

local function ChangeToTransmittingState(self)
  self:ChangeModel()
  self:ChangeState(State.Transmitting)
end

local function ChangeToFlyaway(self)
  self:ChangeState(State.Flyaway, self.modelNode)
end

local function DoIdleState(self)
  if self.oldPointInfo and self.oldPointInfo.zoneMobilizationPointInfo then
    local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(self.oldPointInfo.zoneMobilizationPointInfo.stage)
    if stageType == ZoneMobilizationStageType.Battle_Transfer then
      self:PlayAnimation(Anim.Idle)
      return
    end
  end
  self:PlayEffect(EffectFlag.IdleFire, nil, function()
    self:PlayAnimation(Anim.Idle)
  end)
  self:PlayEffect(EffectFlag.IdleLight)
end

local function OnWorldPointInfoChanged(self, uuid)
  if uuid and CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info then
      if self.oldPointInfo == nil then
        self.oldPointInfo = info
        self:TryChangeCurState(info)
        return
      end
      self:TryChangeCurState(info, self.oldPointInfo)
      self.oldPointInfo = info
    end
  end
end

local function OnBuildDonatedSuccess(self, message)
  if message == nil then
    return
  end
  local point = message.pointId
  if point and CS.SceneManager.World then
    local pointInfo = CS.SceneManager.World:GetPointInfo(point)
    if pointInfo and self.oldPointInfo and self.oldPointInfo.uuid == pointInfo.uuid then
      local newInfo = pointInfo.zoneMobilizationPointInfo
      local oldInfo = self.oldPointInfo.zoneMobilizationPointInfo
      if oldInfo and newInfo and oldInfo.stage < newInfo.stage then
        self.oldPointInfo = pointInfo
        self:ChangeState(State.Upgrade)
        return
      end
      self:ChangeState(State.Build)
      self:OnBuildWorkerAdd(message)
    end
  end
end

local function PlayEffect(self, flag, duration, callback, finishCb)
  if flag then
    if self.allEffect == nil then
      return
    end
    return self:InstantiateAsync(flag, duration, callback, finishCb)
  end
end

local function InstantiateAsync(self, flag, duration, callback, finishCb)
  local path = EffectPath[flag]
  if path then
    path = string.format(path, self.suffix)
    local data = self.allEffect[flag]
    if not data then
      data = {}
      self.allEffect[flag] = data
    else
      self:RemoveEffect(flag)
    end
    local req = CS.GameEntry.Resource:InstantiateAsync(path)
    data.request = req
    req:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      if self.modelNode then
        local parentPath = self:InitEffectRootPath()
        if not string.IsNullOrEmpty(parentPath) then
          local parent = self.modelNode.transform:Find(parentPath)
          if parent then
            tf.parent = parent
          end
        end
      end
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback()
      end
      tf.localScale = ResetScale
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
          self:RemoveEffect(flag)
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = req.gameObject
    end)
    return req
  end
end

local function RemoveEffect(self, flag)
  local data = self.allEffect[flag]
  if data ~= nil then
    if data.delayTimer then
      data.delayTimer:Stop()
      data.delayTimer = nil
    end
    if data.request then
      data.request:Destroy()
      data.request = nil
    end
    data.effectObj = nil
  end
end

local function ClearEffect(self)
  if self.allEffect then
    for _, v in pairs(self.allEffect) do
      if v then
        if v.delayTimer then
          v.delayTimer:Stop()
          v.delayTimer = nil
        end
        if v.request then
          v.request:Destroy()
          v.request = nil
        end
        v.effectObj = nil
      end
    end
    self.allEffect = nil
  end
end

local function InitEffectRootPath(self)
  local path = EffectRootPath1
  if self.oldPointInfo and self.oldPointInfo.zoneMobilizationPointInfo then
    local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(self.oldPointInfo.zoneMobilizationPointInfo.stage)
    if stageType == ZoneMobilizationStageType.Battle_Transfer then
      path = EffectRootPath2
    end
  end
  return path
end

local function OnBuildWorkerAdd(self, message)
  local targetPos = self.transform.position
  self.exitTime = self.constExitTime
  if table.IsNullOrEmpty(self.workers) then
    for i, v in ipairs(workerPosList) do
      local worker = Worker.New()
      worker:Init(v, targetPos)
      table.insert(self.workers, worker)
    end
  end
  local playerInfo = message and message.playerInfo
  if playerInfo then
    local uid = playerInfo.uid
    local worker
    local i = self.buildPlayers[uid]
    if i then
      worker = self.workers[i]
    else
      if self.index >= MAX_NUM then
        self.index = 1
      else
        self.index = self.index + 1
      end
      worker = self.workers[self.index]
      self.buildPlayers[uid] = self.index
    end
    if worker then
      worker:Refresh(message)
    end
  end
end

local function ClearWorkers(self)
  if self.workers then
    for i, v in ipairs(self.workers) do
      if v then
        v:Delete()
      end
      self.workers[i] = nil
    end
  end
  if self.buildPlayers then
    for i, v in ipairs(self.buildPlayers) do
      if v then
        self.buildPlayers[i] = nil
      end
    end
  end
end

ZMBuildingCtrl.InitModelData = InitModelData
ZMBuildingCtrl.InitFsm = InitFsm
ZMBuildingCtrl.ChangeModel = ChangeModel
ZMBuildingCtrl.Destroy = Destroy
ZMBuildingCtrl.OnUpdate = OnUpdate
ZMBuildingCtrl.EnterWorld = EnterWorld
ZMBuildingCtrl.ExitWorld = ExitWorld
ZMBuildingCtrl.ChangeState = ChangeState
ZMBuildingCtrl.PlayAnimation = PlayAnimation
ZMBuildingCtrl.TryChangeCurState = TryChangeCurState
ZMBuildingCtrl.OnWorldPointInfoChanged = OnWorldPointInfoChanged
ZMBuildingCtrl.OnBuildDonatedSuccess = OnBuildDonatedSuccess
ZMBuildingCtrl.GetShowModelData = GetShowModelData
ZMBuildingCtrl.ResetNode = ResetNode
ZMBuildingCtrl.ChangeToBornState = ChangeToBornState
ZMBuildingCtrl.ChangeToIdleState = ChangeToIdleState
ZMBuildingCtrl.ChangeToTransmittingState = ChangeToTransmittingState
ZMBuildingCtrl.ChangeToFlyaway = ChangeToFlyaway
ZMBuildingCtrl.Refresh = Refresh
ZMBuildingCtrl.InitState = InitState
ZMBuildingCtrl.PlayEffect = PlayEffect
ZMBuildingCtrl.InstantiateAsync = InstantiateAsync
ZMBuildingCtrl.RemoveEffect = RemoveEffect
ZMBuildingCtrl.ClearEffect = ClearEffect
ZMBuildingCtrl.DoIdleState = DoIdleState
ZMBuildingCtrl.InitEffectRootPath = InitEffectRootPath
ZMBuildingCtrl.OnBuildWorkerAdd = OnBuildWorkerAdd
ZMBuildingCtrl.ClearWorkers = ClearWorkers
return ZMBuildingCtrl
