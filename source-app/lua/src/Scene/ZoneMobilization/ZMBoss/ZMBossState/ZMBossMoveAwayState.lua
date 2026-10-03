local ZMBossMoveAwayState = BaseClass("ZMBossMoveAwayState")

function ZMBossMoveAwayState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.transform = nil
  self.up = nil
end

function ZMBossMoveAwayState:__delete()
  self.stateMgr = nil
  self.transform = nil
  self.up = nil
end

function ZMBossMoveAwayState:OnEnter(transform)
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayAnimation(stateMgr.Anim.Idle)
    stateMgr:DisplayDeadTipText("activity_godzilla_battle_fail")
  end
  self.transform = transform
  self.up = Vector3.up
end

function ZMBossMoveAwayState:OnExit()
  self.transform = nil
  self.up = nil
end

function ZMBossMoveAwayState:OnUpdate()
  if self.transform and self.up then
    self.transform.position = self.transform.position + self.up * Time.deltaTime * 2
  end
end

return ZMBossMoveAwayState
