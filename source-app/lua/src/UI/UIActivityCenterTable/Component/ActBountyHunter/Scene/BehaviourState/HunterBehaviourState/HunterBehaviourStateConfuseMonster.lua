local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local HunterBehaviourStateConfuseMonster = BaseClass("HunterBehaviourStateConfuseMonster", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function HunterBehaviourStateConfuseMonster:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function HunterBehaviourStateConfuseMonster:OnRemove()
  base.OnRemove(self)
end

function HunterBehaviourStateConfuseMonster:OnEnter(param, shootFlag)
  base.OnEnter(self)
  self:OnExecute(param, shootFlag)
  if self.itemEntity then
    self.itemEntity:ResetAimAngle()
  end
  self:ShowStateLog("[bounty hunter state] Enter HunterBehaviourStateConfuseMonster")
end

function HunterBehaviourStateConfuseMonster:OnExecute(param, shootFlag)
  base.OnExecute(self)
  self.itemEntity:CrossFade("Throw", 0.1)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Xiyin_TL, false)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    if self.itemEntity then
      local nextState = BountyHunterStateType.Idle
      self.itemEntity:ChangeBehaviourState(nextState)
    end
  end, Const.HUNTER_THROW_ANIM_LENGTH)
  self.startChangeSceneTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.itemEntity then
    end
  end, Const.HUNTER_THROW_WAIT_TIME)
end

function HunterBehaviourStateConfuseMonster:OnExit()
  base.OnExit(self)
end

function HunterBehaviourStateConfuseMonster:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.startChangeSceneTimer then
    self.startChangeSceneTimer:Stop()
    self.startChangeSceneTimer = nil
  end
end

HunterBehaviourStateConfuseMonster.__init = __init
HunterBehaviourStateConfuseMonster.__delete = __delete
return HunterBehaviourStateConfuseMonster
