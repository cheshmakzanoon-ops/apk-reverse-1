local S0AllianceBossAttackState = BaseClass("S0AllianceBossAttackState")

function S0AllianceBossAttackState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.soundId = nil
  self.soundTimer = nil
end

function S0AllianceBossAttackState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function S0AllianceBossAttackState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayBossAnimation(stateMgr.BossAnim.Attack, false, true, nil, function()
      stateMgr:ChangeState(stateMgr.FsmState.Idle)
    end)
  end
end

function S0AllianceBossAttackState:OnExit()
end

function S0AllianceBossAttackState:OnUpdate(deltaTime)
end

return S0AllianceBossAttackState
