local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStatePatrol = BaseClass("MonsterBehaviourStatePatrol", BaseBehaviourState)
local base = BaseBehaviourState
local PATROL_RADIUS = 1
local PATROL_TIME = 5
local PATROL_ANGLE_OFFSET = 90

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStatePatrol:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStatePatrol:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStatePatrol:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStatePatrol. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStatePatrol:OnExecute(param)
  base.OnExecute(self)
  self:MoveTosRandomPos()
end

function MonsterBehaviourStatePatrol:MoveTosRandomPos()
  local movePos = self:GetOnePatrolPoint()
  if not movePos then
    return
  end
  local isFaceTarget = true
  self.itemEntity:MoveToTargetPos(movePos, PATROL_TIME, "walk", isFaceTarget, function()
    self:CheckContinueStepAction()
  end)
end

function MonsterBehaviourStatePatrol:CheckContinueStepAction()
  if not self.itemEntity then
    return
  end
  local randomVal = math.random(1, 10)
  if 5 < randomVal then
    self:MoveTosRandomPos()
  else
    self.itemEntity:ChangeBehaviourState(BountyMonsterStateType.Idle)
  end
end

function MonsterBehaviourStatePatrol:GetOnePatrolPoint()
  if not self.itemEntity then
    return
  end
  if self.itemEntity:IsFlyMonster() then
    return self:GetFlyMonsterPatrolPoint()
  else
    return self:GetNormalMonsterPatrolPoint()
  end
end

function MonsterBehaviourStatePatrol:GetNormalMonsterPatrolPoint()
  local hunterWorldPos = self.itemEntity.hunterWorldPos
  local monsterToHunterDir = hunterWorldPos - self.itemEntity.birthWorldPos
  monsterToHunterDir = Vector3.New(monsterToHunterDir.x, 0, monsterToHunterDir.z)
  local randomAngle = math.random(-PATROL_ANGLE_OFFSET, PATROL_ANGLE_OFFSET)
  local newDir = Quaternion.AngleAxis(randomAngle, Vector3.up) * monsterToHunterDir
  local randomOffset = newDir:SetNormalize() * PATROL_RADIUS
  local targetPos = self.itemEntity.birthWorldPos + randomOffset
  return targetPos
end

function MonsterBehaviourStatePatrol:GetFlyMonsterPatrolPoint()
  local cameraDir = self.itemEntity.cameraDir
  cameraDir = Vector3.New(cameraDir.x, 0, cameraDir.z)
  local monsterDir = Vector3.New(self.itemEntity.transform.forward.x, 0, self.itemEntity.transform.forward.z)
  local angleOfCamera2Monster = Vector3.Angle(cameraDir, monsterDir)
  local rotateAngle = 0
  if math.abs(angleOfCamera2Monster) > 91 then
    rotateAngle = 0 < math.random(-1, 1) and 90 or -90
  else
    local cross = Vector3.Cross(cameraDir, monsterDir)
    local isRight = 0 < cross.y
    rotateAngle = isRight and -90 or 90
  end
  local patrolDir = Quaternion.AngleAxis(rotateAngle, Vector3.up) * cameraDir
  local targetPos = self.itemEntity.birthWorldPos + patrolDir * PATROL_RADIUS
  return targetPos
end

function MonsterBehaviourStatePatrol:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStatePatrol:StopAllTimerAndTween()
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

MonsterBehaviourStatePatrol.__init = __init
MonsterBehaviourStatePatrol.__delete = __delete
return MonsterBehaviourStatePatrol
