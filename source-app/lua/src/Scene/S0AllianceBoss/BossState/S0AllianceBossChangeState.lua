local S0AllianceBossChangeState = BaseClass("S0AllianceBossChangeState")

function S0AllianceBossChangeState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function S0AllianceBossChangeState:__delete()
  self:OnExit()
  self.stateMgr = nil
end

function S0AllianceBossChangeState:OnEnter(curStage)
  local stateMgr = self.stateMgr
  if stateMgr then
    local function changeIdleCallback()
      stateMgr:ChangeState(stateMgr.FsmState.Idle)
    end
    
    local function playBornCallback()
      stateMgr:PlayBossAnimation(stateMgr.BossAnim.Born2, false, true, nil, changeIdleCallback)
      stateMgr:ChangeMaterial(curStage)
    end
    
    stateMgr:PlayBossAnimation(stateMgr.BossAnim.Death, false, true, nil, playBornCallback)
  end
end

function S0AllianceBossChangeState:OnExit()
end

function S0AllianceBossChangeState:OnUpdate(deltaTime)
end

return S0AllianceBossChangeState
