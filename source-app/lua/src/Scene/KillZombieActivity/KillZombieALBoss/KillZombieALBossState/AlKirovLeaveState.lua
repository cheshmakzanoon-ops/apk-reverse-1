local AlKirovLeaveState = BaseClass("AlKirovLeaveState")

function AlKirovLeaveState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovLeaveState:__delete()
  self.stateMgr = nil
end

function AlKirovLeaveState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Escape)
  end
end

function AlKirovLeaveState:OnUpdate(deltaTime)
end

return AlKirovLeaveState
