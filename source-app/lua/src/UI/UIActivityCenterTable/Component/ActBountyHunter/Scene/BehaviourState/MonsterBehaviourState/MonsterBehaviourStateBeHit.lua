local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateBeHit = BaseClass("MonsterBehaviourStateBeHit", BaseBehaviourState)
local base = BaseBehaviourState
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local BE_HIT_TIME = 0.5
local BE_HIT_DISTANCE = 0.5

local function __init(self)
  base.__init(self)
  self.beHitTimer = nil
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateBeHit:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateBeHit:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateBeHit:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateBeHit. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateBeHit:OnExecute(params)
  base.OnExecute(self)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterOnMonsterBeHitEnd, params)
  local ret, time = self.itemEntity:PlayAni("hurt")
  local delayTime = BE_HIT_TIME
  if ret then
    delayTime = time
  end
  if self.itemEntity:IsDied() then
    delayTime = 0.01
  end
  if self.itemEntity:IsBoss() then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Boss_Hit, false)
  end
  if self.itemEntity and params and params.newHp then
    self.itemEntity:UpdateHp(params.newHp)
  end
  self:StopAllTimerAndTween()
  
  function self.executeFunc()
    self.executeFunc = nil
    self:CheckMonsterIsDied(params)
  end
  
  self.beHitTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.beHitTimer = nil
    self.executeFunc()
  end, delayTime)
end

function MonsterBehaviourStateBeHit:HitMove(hitDir)
  if not (hitDir and self.itemEntity) or not self.itemEntity.transform then
    return
  end
  local targetPos = self.itemEntity.transform.position + hitDir * BE_HIT_DISTANCE
  local isFaceTarget = false
  self.itemEntity:MoveToTargetPos(targetPos, BE_HIT_TIME, nil, isFaceTarget, function()
  end)
end

function MonsterBehaviourStateBeHit:CheckMonsterIsDied(params)
  self:ShowStateLog("[bounty hunter state] CheckMonsterIsDied. uid: " .. self.itemEntity.monsterData.uuid)
  if not self.itemEntity then
    return
  end
  if self.itemEntity:IsDied() then
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Dead, params)
  else
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Idle)
  end
end

function MonsterBehaviourStateBeHit:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
  if self.executeFunc then
    self.executeFunc()
  end
end

function MonsterBehaviourStateBeHit:StopAllTimerAndTween()
  base.StopAllTimerAndTween(self)
  if self.beHitTimer then
    self.beHitTimer:Stop()
    self.beHitTimer = nil
  end
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

MonsterBehaviourStateBeHit.__init = __init
MonsterBehaviourStateBeHit.__delete = __delete
return MonsterBehaviourStateBeHit
