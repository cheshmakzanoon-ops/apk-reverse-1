local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateBirth = BaseClass("MonsterBehaviourStateBirth", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateBirth:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateBirth:OnRemove()
  base.OnRemove(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function MonsterBehaviourStateBirth:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateBirth. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateBirth:OnExecute(param)
  base.OnExecute(self)
  local ret, time = self.itemEntity:PlayAni("born")
  if not ret then
    time = 1
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    if self.itemEntity then
      local gotoState = self.itemEntity:IsBoss() and BountyMonsterStateType.Idle or BountyMonsterStateType.Patrol
      self.itemEntity:ChangeBehaviourState(gotoState)
    end
  end, time)
  if self.itemEntity:IsBoss() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Boss_Show_TL, false)
  end
end

function MonsterBehaviourStateBirth:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateBirth:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

MonsterBehaviourStateBirth.__init = __init
MonsterBehaviourStateBirth.__delete = __delete
return MonsterBehaviourStateBirth
