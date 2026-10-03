local WorkerStateIdle = BaseClass("WorkerStateIdle")
local Const = require("Scene.BuildDispatchingHero.Const")

function WorkerStateIdle:__init(worker)
  self.worker = worker
end

function WorkerStateIdle:__delete()
  self.worker = nil
end

function WorkerStateIdle:OnEnter()
  if self.worker:IsInEndPos() then
    self.worker:PlayAnim(Const.WorkerAnim.CarryIdle)
  elseif self.worker:IsInStartPos() then
    self.worker:PlayAnim(Const.WorkerAnim.Idle)
  else
    self.worker:PlayAnim(Const.WorkerAnim.Idle)
  end
end

function WorkerStateIdle:OnExit()
end

function WorkerStateIdle:OnUpdate(deltaTime)
end

return WorkerStateIdle
