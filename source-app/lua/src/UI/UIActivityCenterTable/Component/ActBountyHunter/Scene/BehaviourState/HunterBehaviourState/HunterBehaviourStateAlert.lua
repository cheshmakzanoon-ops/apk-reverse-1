local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateAlert = BaseClass("HunterBehaviourStateAlert", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
  self.exitAlertTimer = nil
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateAlert:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateAlert:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateAlert:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateAlert")
end

function HunterBehaviourStateAlert:OnExecute(param)
  base.OnExecute(self)
  if not (param and param.targetItem) or not self.itemEntity then
    return
  end
  local targetPos = self.itemEntity:GetAimingWorldPos()
  if targetPos then
    self.itemEntity:AimTarget(targetPos)
  end
  if self.itemEntity:IsAimingBoss() then
    self.itemEntity:CrossFade("Aim2", 0.1)
  else
    self.itemEntity:CrossFade("Aim", 0.1)
  end
  if self.exitAlertTimer then
    self.exitAlertTimer:Stop()
    self.exitAlertTimer = nil
  end
  self.exitAlertTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
      local isTryReload = math.random(1, 10) > 9 and self.itemEntity:IsAimingBoss()
      local turnBackParam = {}
      turnBackParam.nextStateType = BountyHunterStateType.Idle
      if isTryReload then
        turnBackParam.nextStateType = BountyHunterStateType.Reload
      end
      self.itemEntity:ResetAimAngle()
      self.itemEntity:ChangeBehaviourState(BountyHunterStateType.TurnBack, turnBackParam)
    end
  end, Const.HUNTER_ALERT_MAX_DURATION)
end

function HunterBehaviourStateAlert:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateAlert:StopAllTimerAndTween()
  if self.exitAlertTimer then
    self.exitAlertTimer:Stop()
    self.exitAlertTimer = nil
  end
end

HunterBehaviourStateAlert.__init = __init
HunterBehaviourStateAlert.__delete = __delete
return HunterBehaviourStateAlert
