local JobHero = BaseClass("JobHero")
local Const = require("Scene.BuildDispatchingHero.Const")
local FSM = require("Framework.Common.FSM")
local WorkerStateIdle = require("Scene.BuildDispatchingHero.WorkerState.WorkerStateIdle")
local WorkerStateMove = require("Scene.BuildDispatchingHero.WorkerState.WorkerStateMove")
local WorkerStateWork = require("Scene.BuildDispatchingHero.WorkerState.WorkerStateWork")
local WorkerConsignment = require("Scene.BuildDispatchingHero.WorkerState.WorkerStateConsignment")
local CarryObject = require("Scene.BuildDispatchingHero.Lading.LadingObject")
local Resource = CS.GameEntry.Resource

function JobHero:__init()
  self.position = nil
  self.rotateion = nil
  self.gameObject = nil
  self.simpleAnim = nil
  self.update = nil
  self.isVisible = nil
  self.updateTimer = nil
  self.update = nil
  self.carryObj = {}
end

function JobHero:GetModelPath(uuid)
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(uuid)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(workerData.modelId)
  return GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "city_model_path")
end

function JobHero:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(Const.WorkerState.Idle, WorkerStateIdle.New(self))
  self.fsm:AddState(Const.WorkerState.Move, WorkerStateMove.New(self))
  self.fsm:AddState(Const.WorkerState.Work, WorkerStateWork.New(self))
  self.fsm:AddState(Const.WorkerState.Consignment, WorkerConsignment.New(self))
  self:UpdateState(Const.WorkerState.Idle)
  
  function self.__update_handle()
    self:OnUpdate()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

function JobHero:IsGetBuildPos()
  if table.IsNullOrEmpty(self.startPos) or table.IsNullOrEmpty(self.endPos) then
    return false
  end
  if IsNull(self.startPos.entry) or IsNull(self.endPos.entry) then
    return false
  end
  return true
end

function JobHero:Create(delayTime, uuid, jobHeroData, callback)
  self.data = jobHeroData
  self.startPos = jobHeroData:GetStartBuildPos()
  self.endPos = jobHeroData:GetEndBuildPos()
  if not self:IsGetBuildPos() then
    return
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.req = Resource:InstantiateAsync(self:GetModelPath(jobHeroData.heroUuid))
    self.req:completed("+", function(req)
      if not req or not req.gameObject then
        return
      end
      self:InitFSM()
      self.gameObject = req.gameObject
      self.transform = req.gameObject.transform
      self.transform:Set_position(self.startPos.entry.x, self.startPos.entry.y, self.startPos.entry.z)
      self.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      self.carryRoot = self.transform:Find("A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/Root_M/ResRootObj")
      self.gameObject.name = "jobHero" .. tostring(uuid)
      self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      self:OnEndWork()
      self.movePos = self.startPos.entry
      self.endCallback = callback
      self.sickle = self.transform:Find("A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/Wrist_R/IndexFinger1_R/IndexFinger2_R/A_soldie_ben_sickle")
    end)
  end, delayTime)
end

function JobHero:GetPosition()
  if self.transform then
    return self.transform.position
  end
end

function JobHero:SetPosition(pos)
  if self.transform and pos then
    self.transform.position = pos
  end
end

function JobHero:PlayAnim(name)
  if self.simpleAnim then
    self.simpleAnim:Play(name)
  end
end

function JobHero:OnUpdate()
  if self.fsm then
    self.fsm:OnUpdate()
  end
end

function JobHero:SetRotation(rotation)
  self.transform.rotation = rotation
end

function JobHero:GetCarryRoot()
  return self.carryRoot
end

function JobHero:UpdateBuildPos()
  self.startPos = self.data:GetStartBuildPos()
  self.endPos = self.data:GetEndBuildPos()
  self:UpdateState(self.state, self.moveState, self.isWork)
end

function JobHero:UpdateState(state, moveState, isWork)
  self.fsm:ChangeState(Const.WorkerState.Idle)
  self.fsm:ChangeState(state, moveState, isWork)
  self.state = state
  if state == Const.WorkerState.Move then
    self.moveState = moveState
    self.isWork = isWork
  end
end

function JobHero:OnEndWork()
  self:UpdateState(Const.WorkerState.Idle)
  if self.data:GetEndBuild() and self.endPos.entry then
    local count = self.data.garbage_max and self.data.garbage_max or Const.maxCount
    for i = 1, count do
      self:CarryOneObject()
    end
    self:SetPosition(self.startPos.p_exit)
    self:UpdateState(Const.WorkerState.Move, Const.WorkerMoveEndState.endPos, true)
  else
    self:UpdateState(Const.WorkerState.Work, self.startPos.working)
  end
end

function JobHero:OnConsignmentEnd()
  self.carryObj = {}
  self:UpdateState(Const.WorkerState.Move, Const.WorkerMoveEndState.startPos)
end

function JobHero:OnArriveWayPoint()
  self:UpdateState(Const.WorkerState.Idle)
  if self:IsInStartPos() then
    if self.endCallback then
      self.endCallback()
    end
  elseif self:IsInEndPos() then
    self:UpdateState(Const.WorkerState.Consignment)
  end
end

function JobHero:CarryOneObject(t)
  local count = #self.carryObj == nil and 0 or #self.carryObj
  local isShow = true
  if isShow then
    local index = count + 1
    local carryObj = CarryObject.New(self)
    local param = {}
    param.resType = t
    param.localPos = self:BagIndexToPos(index)
    param.visible = index <= 10
    param.path = Const.GrbagePath .. Const.Garbage[self.data.buildItemId]
    carryObj:ReInit(param)
    if param.visible then
      carryObj:Create()
    end
    self.carryObj[index] = carryObj
  end
end

function JobHero:IsInEndPos()
  local isInEndPos = false
  if IsNull(self.endPos) or IsNull(self.transform) then
    return
  end
  for i, v in pairs(self.endPos) do
    if not IsNull(v) and Vector3.Distance(self.transform.position, v) < 0.05 then
      isInEndPos = true
    end
  end
  return isInEndPos
end

function JobHero:IsInStartPos()
  local isInStartPos = false
  if self.startPos and not IsNull(self.transform) then
    for i, v in pairs(self.startPos) do
      if not IsNull(v) and Vector3.Distance(self.transform.position, v) < 0.05 then
        isInStartPos = true
      end
    end
  end
  return isInStartPos
end

function JobHero:BagIndexToPos(index)
  index = index - 1
  local pos
  local max = Const.maxCount
  local perRowCount = 1
  local row = math.floor(index / perRowCount)
  local col = index % perRowCount
  local maxRow = 1
  if index >= max then
    pos = Vector3.New(perRowCount * -0.19, -0.25 - 0.17 * maxRow, 0)
  else
    pos = Vector3.New(col * -0.19, -0.25 - 0.17 * row, 0)
  end
  return pos
end

function JobHero:__delete()
  self.updateTimer = nil
  if #self.carryObj > 0 then
    for i, v in pairs(self.carryObj) do
      v:Destroy()
    end
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.endCallback = nil
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.position = nil
  self.rotateion = nil
  self.gameObject = nil
  self.simpleAnim = nil
  self.update = nil
  self.isVisible = nil
  self.update = nil
end

return JobHero
