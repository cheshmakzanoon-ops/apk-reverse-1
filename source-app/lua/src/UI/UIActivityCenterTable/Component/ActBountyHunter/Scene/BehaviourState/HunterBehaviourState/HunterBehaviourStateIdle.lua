local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateIdle = BaseClass("HunterBehaviourStateIdle", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateIdle:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateIdle:OnRemove()
  base.OnRemove(self)
end

function HunterBehaviourStateIdle:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  if self.itemEntity then
    self.itemEntity:ResetAimAngle()
  end
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateIdle")
end

function HunterBehaviourStateIdle:OnExecute(param)
  base.OnExecute(self)
  if self.itemEntity:IsAimingBoss() then
    self.itemEntity:CrossFade("Idle2", 0.1)
  else
    self.itemEntity:CrossFade("Idle", 0.1)
  end
end

function HunterBehaviourStateIdle:OnExit()
  base.OnExit(self)
end

HunterBehaviourStateIdle.__init = __init
HunterBehaviourStateIdle.__delete = __delete
return HunterBehaviourStateIdle
