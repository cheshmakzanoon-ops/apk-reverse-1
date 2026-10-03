local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateChangeGun = BaseClass("HunterBehaviourStateChangeGun", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateChangeGun:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateChangeGun:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateChangeGun:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateChangeGun")
end

function HunterBehaviourStateChangeGun:OnExecute(param)
  base.OnExecute(self)
  self.itemEntity:ResetAimAngle()
  if param.preItem.monsterQuality == BountyMonsterQualityType.Boss and param.curItem.monsterQuality ~= BountyMonsterQualityType.Boss then
    self.itemEntity:CrossFade("ChangeGun21", 0.1)
  elseif param.preItem.monsterQuality ~= BountyMonsterQualityType.Boss and param.curItem.monsterQuality == BountyMonsterQualityType.Boss then
    self.itemEntity:CrossFade("ChangeGun12", 0.1)
  end
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
  self.delayEnterNextStateTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
      self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
    end
  end, Const.HUNTER_CHANGE_GUN_ANIM_LENGTH)
end

function HunterBehaviourStateChangeGun:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateChangeGun:StopAllTimerAndTween()
  if self.delayEnterNextStateTimer then
    self.delayEnterNextStateTimer:Stop()
    self.delayEnterNextStateTimer = nil
  end
end

HunterBehaviourStateChangeGun.__init = __init
HunterBehaviourStateChangeGun.__delete = __delete
return HunterBehaviourStateChangeGun
