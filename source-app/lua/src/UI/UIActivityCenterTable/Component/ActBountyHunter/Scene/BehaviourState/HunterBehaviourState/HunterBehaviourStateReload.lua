local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateReload = BaseClass("HunterBehaviourStateReload", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateReload:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateReload:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateReload:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  if self.itemEntity then
    self.itemEntity:ResetAimAngle()
  end
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateReload")
end

function HunterBehaviourStateReload:OnExecute(param)
  base.OnExecute(self)
  local isAimingBoss = self.itemEntity:IsAimingBoss()
  if isAimingBoss then
    if self.itemEntity then
      self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
    end
  else
    self.itemEntity:CrossFade("Reload", 0.1)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Huandan_TL, false)
    local time = Const.HUNTER_RELOAD_ANIM_LENGTH
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.itemEntity then
        self.itemEntity:ChangeBehaviourState(BountyHunterStateType.Idle)
      end
    end, time)
  end
end

function HunterBehaviourStateReload:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function HunterBehaviourStateReload:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

HunterBehaviourStateReload.__init = __init
HunterBehaviourStateReload.__delete = __delete
return HunterBehaviourStateReload
