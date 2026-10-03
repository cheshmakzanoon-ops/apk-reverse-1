local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateTurnFront = BaseClass("HunterBehaviourStateTurnFront", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateTurnFront:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateTurnFront:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateTurnFront:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateTurnFront")
end

function HunterBehaviourStateTurnFront:OnExecute(param)
  base.OnExecute(self)
  if not param or param.nextStateType ~= BountyHunterStateType.Attack or param.nextStateParam.targetItem then
  end
  if self.itemEntity:IsAimingBoss() then
    self.itemEntity:CrossFade("TurnFront2", 0.1)
  else
    self.itemEntity:CrossFade("TurnFront", 0.1)
  end
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
  self.delayEnterNextStateTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity and param and param.nextStateType then
      self.itemEntity:ChangeBehaviourState(param.nextStateType, param.nextStateParam)
    end
  end, Const.HUNTER_TURN_FRONT_ANIM_LENGTH)
end

function HunterBehaviourStateTurnFront:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateTurnFront:StopAllTimerAndTween()
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
end

HunterBehaviourStateTurnFront.__init = __init
HunterBehaviourStateTurnFront.__delete = __delete
return HunterBehaviourStateTurnFront
