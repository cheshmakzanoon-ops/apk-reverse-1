local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateIdle = BaseClass("MonsterBehaviourStateIdle", BaseBehaviourState)
local base = BaseBehaviourState
local THINK_TIME = 2

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateIdle:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateIdle:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateIdle:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateIdle. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateIdle:OnExecute(param)
  base.OnExecute(self)
  self.itemEntity:CrossFade("idle")
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if not self.itemEntity:IsBoss() then
    self:ThinkingTime()
  end
end

function MonsterBehaviourStateIdle:ThinkingTime()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:CheckContinueStepAction()
  end, THINK_TIME)
end

function MonsterBehaviourStateIdle:CheckContinueStepAction()
  if not self.itemEntity then
    return
  end
  local randomVal = math.random(1, 10)
  if 5 < randomVal then
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Patrol)
  else
    self:ThinkingTime()
  end
end

function MonsterBehaviourStateIdle:OnExit()
  base.OnExit(self)
  self:ShowStateLog("[bounty hunter state] Exit MonsterBehaviourStateIdle. uid: " .. self.itemEntity.monsterData.uuid)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateIdle:StopAllTimerAndTween()
  if self.timer then
    self:ShowStateLog("[bounty hunter state] MonsterBehaviourStateIdle.KillTimer. uid: " .. self.itemEntity.monsterData.uuid)
    self.timer:Stop()
    self.timer = nil
  end
end

MonsterBehaviourStateIdle.__init = __init
MonsterBehaviourStateIdle.__delete = __delete
return MonsterBehaviourStateIdle
