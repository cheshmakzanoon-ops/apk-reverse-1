local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateTurnBack = BaseClass("HunterBehaviourStateTurnBack", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateTurnBack:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateTurnBack:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateTurnBack:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateTurnBack")
end

function HunterBehaviourStateTurnBack:OnExecute(param)
  base.OnExecute(self)
  if self.itemEntity:IsAimingBoss() then
    self.itemEntity:CrossFade("TurnBack2", 0.1)
  else
    self.itemEntity:CrossFade("TurnBack", 0.1)
  end
  self.itemEntity:ResetAimAngle()
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
  self.delayEnterNextStateTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity and param and param.nextStateType then
      self.itemEntity:ChangeBehaviourState(param.nextStateType, param.nextStateParam)
    end
  end, Const.HUNTER_TURN_BACK_ANIM_LENGTH)
end

function HunterBehaviourStateTurnBack:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateTurnBack:StopAllTimerAndTween()
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
end

HunterBehaviourStateTurnBack.__init = __init
HunterBehaviourStateTurnBack.__delete = __delete
return HunterBehaviourStateTurnBack
