local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateBirth = BaseClass("HunterBehaviourStateBirth", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateBirth:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateBirth:OnRemove()
  base.OnRemove(self)
end

function HunterBehaviourStateBirth:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateBirth")
end

function HunterBehaviourStateBirth:OnExecute(param)
  base.OnExecute(self)
  self.itemEntity:ResetMagicaPhysics()
  local ret, time = self.itemEntity:PlayAni("Enter")
  if not ret then
    time = 1
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
      self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
      self.itemEntity:ResetMagicaPhysics()
    end
  end, time)
end

function HunterBehaviourStateBirth:OnExit()
  base.OnExit(self)
end

HunterBehaviourStateBirth.__init = __init
HunterBehaviourStateBirth.__delete = __delete
return HunterBehaviourStateBirth
