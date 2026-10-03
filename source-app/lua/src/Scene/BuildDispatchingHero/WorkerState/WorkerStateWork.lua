local WorkerStateWork = BaseClass("WorkerStateWork")
local Const = require("Scene.BuildDispatchingHero.Const")

function WorkerStateWork:__init(worker)
  self.worker = worker
end

function WorkerStateWork:__delete()
  if self.worker.sickle and not IsNull(self.worker.sickle.gameObject) then
    self.worker.sickle.gameObject:SetActive(false)
  end
  if self.workerDelay then
    self.workerDelay:Stop()
    self.workerDelay = nil
  end
  self.worker = nil
end

function WorkerStateWork:OnEnter()
  local animName = Const.WorkerWorkAnim[self.worker.data.startBuildItemId]
  if self.worker.sickle and animName == "harvest" then
    self.worker.sickle.gameObject:SetActive(true)
  end
  self.worker:SetPosition(self.worker.startPos.working)
  self.startPos = self.worker:GetPosition()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.worker.data.startBuildUuid)
  local pos = buildData:GetCenterVec()
  local lookRot = Quaternion.LookRotation(Vector3.Normalize(pos - self.startPos), Vector3.up)
  self.worker:SetRotation(lookRot)
  self.worker:PlayAnim(animName)
  self.workerDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.worker:OnEndWork()
  end, Const.WorkerTime)
end

function WorkerStateWork:OnExit()
  self.worker:SetPosition(self.worker.startPos.p_exit)
  if self.worker.sickle then
    self.worker.sickle.gameObject:SetActive(false)
  end
  if self.workerDelay then
    self.workerDelay:Stop()
    self.workerDelay = nil
  end
end

function WorkerStateWork:OnUpdate(deltaTime)
end

return WorkerStateWork
