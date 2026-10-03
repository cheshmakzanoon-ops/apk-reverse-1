local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateFullAtk = BaseClass("HunterBehaviourStateFullAtk", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateFullAtk:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateFullAtk:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateFullAtk:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateFullAtk")
end

function HunterBehaviourStateFullAtk:OnExecute(param)
  base.OnExecute(self)
  if self.timer then
    self.timer:Stop()
  end
  self.itemEntity:ResetAimAngle()
  self.itemEntity:CrossFade("FullAtk", 0.1)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Huojian_TL, false)
  local aniTime = self.itemEntity:GetAniTime("FullAtk")
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
      self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
    end
  end, aniTime)
end

function HunterBehaviourStateFullAtk:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateFullAtk:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

HunterBehaviourStateFullAtk.__init = __init
HunterBehaviourStateFullAtk.__delete = __delete
return HunterBehaviourStateFullAtk
