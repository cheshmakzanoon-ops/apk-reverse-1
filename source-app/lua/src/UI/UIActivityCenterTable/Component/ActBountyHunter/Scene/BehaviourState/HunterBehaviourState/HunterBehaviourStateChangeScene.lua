local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateChangeScene = BaseClass("HunterBehaviourStateChangeScene", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
  self.timer = nil
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateChangeScene:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateChangeScene:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateChangeScene:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  if self.itemEntity then
    self.itemEntity:ResetAimAngle()
  end
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateChangeScene")
end

function HunterBehaviourStateChangeScene:OnExecute(changeSceneTime, turnDir)
  base.OnExecute(self)
  self:StopAllTimerAndTween()
  local animTime = 5
  if turnDir == BountyHunterSceneDoorType.Right then
    animTime = self.itemEntity:GetClipLength("Right")
    self.itemEntity:CrossFade("Right", 0.1)
  else
    animTime = self.itemEntity:GetClipLength("Left")
    self.itemEntity:CrossFade("Left", 0.1)
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
  end, animTime)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Kimberly_Run_TL, false)
end

function HunterBehaviourStateChangeScene:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateChangeScene:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

HunterBehaviourStateChangeScene.__init = __init
HunterBehaviourStateChangeScene.__delete = __delete
return HunterBehaviourStateChangeScene
