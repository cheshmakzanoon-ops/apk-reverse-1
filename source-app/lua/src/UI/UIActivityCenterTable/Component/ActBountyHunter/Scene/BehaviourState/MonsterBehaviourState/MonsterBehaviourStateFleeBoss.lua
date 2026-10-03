local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateFleeBoss = BaseClass("MonsterBehaviourStateFleeBoss", BaseBehaviourState)
local base = BaseBehaviourState
local FLEE_DISTANCE = 4
local FLEE_TIME = 0.5

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateFleeBoss:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateFleeBoss:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateFleeBoss:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateFleeBoss. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateFleeBoss:OnExecute(params)
  base.OnExecute(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:GotoFleePoint(params)
end

function MonsterBehaviourStateFleeBoss:GotoFleePoint(params)
  if not self.itemEntity then
    return
  end
  local bossWorldPos = params.bossWorldPos
  local hunterWorldPos = params.hunterWorldPos
  local monsterWorldPos = self.itemEntity.transform.position
  if not (bossWorldPos and hunterWorldPos) or not monsterWorldPos then
    Logger.LogError("some Pos is nil! plz check it !")
    return
  end
  local hunterToBossDir = bossWorldPos - hunterWorldPos
  local hunterToMonsterDir = monsterWorldPos - hunterWorldPos
  local cross = Vector3.Cross(hunterToBossDir, hunterToMonsterDir)
  local isRight = cross.y > 0
  local dir = Vector3.Normalize(Vector3.Cross(hunterToBossDir, Vector3.up * (isRight and -1 or 1)))
  local targetPos = monsterWorldPos + dir * FLEE_DISTANCE
  local aniName = isRight and "rightHit" or "leftHit"
  local isFaceTarget = false
  self.itemEntity:MoveToTargetPos(targetPos, FLEE_TIME, aniName, isFaceTarget, function()
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Stun)
  end)
  local monsterToHunterDir = Vector3.New(hunterWorldPos.x, 0, hunterWorldPos.z) - Vector3.New(monsterWorldPos.x, 0, monsterWorldPos.z)
  local targetRot = Quaternion.LookRotation(monsterToHunterDir)
  self.itemEntity.transform.rotation = targetRot
end

function MonsterBehaviourStateFleeBoss:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateFleeBoss:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

MonsterBehaviourStateFleeBoss.__init = __init
MonsterBehaviourStateFleeBoss.__delete = __delete
return MonsterBehaviourStateFleeBoss
