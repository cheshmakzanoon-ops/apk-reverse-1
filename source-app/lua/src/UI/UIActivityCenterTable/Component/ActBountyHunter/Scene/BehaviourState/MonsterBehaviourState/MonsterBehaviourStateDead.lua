local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateDead = BaseClass("MonsterBehaviourStateDead", BaseBehaviourState)
local base = BaseBehaviourState
local DEAD_TIME = 1.5

local function __init(self)
  base.__init(self)
  self.deadTimer = nil
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateDead:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateDead:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateDead:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateDead. uid: " .. self.itemEntity.monsterData.uuid)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterOnMonsterEnterDead, param)
  local ret, time = self.itemEntity:PlayAni("dead")
  local deadTime = DEAD_TIME
  if ret then
    deadTime = time
  end
  if self.itemEntity:IsBoss() then
  end
  self.deadTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.deadTimer = nil
    self:SendRemoveMonsterEntityMsg()
  end, deadTime)
  self:CheckFlyMonsterDropAni()
end

function MonsterBehaviourStateDead:CheckFlyMonsterDropAni()
  if not (self.itemEntity:IsFlyMonster() and self.itemEntity.monsterData) or not self.itemEntity.scene then
    return
  end
  local monsterTmp = self.itemEntity.monsterData.monsterTmp
  local deadAniParams = monsterTmp.dead_ani_param
  if #deadAniParams < 2 then
    return
  end
  local preDieTime = deadAniParams[1]
  local dropTime = deadAniParams[2]
  local dropTargetPos = self.itemEntity.transform.position
  if self.itemEntity.scene.curSceneObjInfo then
    local scenePosY = self.itemEntity.scene.curSceneObjInfo:GetCurSceneWorldPos().y
    dropTargetPos = Vector3.New(dropTargetPos.x, scenePosY, dropTargetPos.z)
  end
  local isFaceTarget = false
  self.itemEntity:MoveToTargetPos(dropTargetPos, dropTime, nil, isFaceTarget, function()
    self.itemEntity:StopMove()
  end, preDieTime, CS.DG.Tweening.Ease.InCirc)
end

function MonsterBehaviourStateDead:OnExecute(param)
  base.OnExecute(self)
end

function MonsterBehaviourStateDead:SendRemoveMonsterEntityMsg()
  if self.itemEntity then
    local params = {}
    params.actionType = BountyHunterAniActionType.MonsterRemove
    params.triggerType = BountyHunterActionTriggerType.Immediate
    params.data = self.itemEntity.monsterData.uuid
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end
end

function MonsterBehaviourStateDead:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
  if self.deadTimer then
    self:SendRemoveMonsterEntityMsg()
  end
end

function MonsterBehaviourStateDead:StopAllTimerAndTween()
  if self.deadTimer then
    self.deadTimer:Stop()
    self.deadTimer = nil
  end
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

function MonsterBehaviourStateDead:CheckIsCanExitState(nextState)
  return false
end

MonsterBehaviourStateDead.__init = __init
MonsterBehaviourStateDead.__delete = __delete
return MonsterBehaviourStateDead
