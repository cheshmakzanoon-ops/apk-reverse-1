local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local Const = require("Scene.PVEBattleLevel.Const")
local FollowPlayerStopAttackState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerStopAttackState")
local FollowPlayerAttackState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerAttackState")
local FollowPlayerDeadState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerDeadState")
local FollowPlayerStopMoveState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerStopMoveState")
local FollowPlayerMoveState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerMoveState")
local FollowPlayerQueueMoveState = require("Scene.PVEBattleLevel.FollowPlayer.FollowPlayerQueueMoveState")
local FollowPlayer = BaseClass("FollowPlayer")
FollowPlayer.State = {
  StopAttack = 1,
  Attack = 2,
  Dead = 3
}
FollowPlayer.MoveState = {
  StopMove = 1,
  Move = 2,
  QueueMove = 3
}
FollowPlayer.Anim = {
  StopAttack = "StopAttack",
  Attack = "Attack",
  Dead = "Dead"
}
FollowPlayer.MoveAnim = {Stand = "Stand", Run = "Run"}
FollowPlayer.QueueSpace = 1.5
local AnimTriggerList = {
  "Stand_StopAttack",
  "Run_StopAttack",
  "Stand_Attack",
  "Run_Attack",
  "Stand_Dead"
}
local State = FollowPlayer.State
local MoveState = FollowPlayer.MoveState
local Anim = FollowPlayer.Anim
local MoveAnim = FollowPlayer.MoveAnim

local function SetState(player, stateIndex, ...)
  if player.currStateIndex == stateIndex then
    return
  end
  player.currState:OnExit()
  player.currStateIndex = stateIndex
  player.currState = player.stateList[player.currStateIndex]
  player.currState:OnEnter(...)
end

local function SetMoveState(player, stateIndex, ...)
  if player.currMoveStateIndex == stateIndex then
    return
  end
  player.currMoveState:OnExit()
  player.currMoveStateIndex = stateIndex
  player.currMoveState = player.moveStateList[player.currMoveStateIndex]
  player.currMoveState:OnEnter(...)
end

function FollowPlayer:__init(battleLevel, objId)
  self.objId = objId
  self.position = Vector3.zero
  self.rotation = Quaternion.identity
  self.currStateIndex = State.StopAttack
  self.currState = nil
  self.currMoveStateIndex = State.StopMove
  self.currMoveState = nil
  self.currMoveAnim = nil
  self.currAnim = nil
  self.battleLevel = battleLevel
  self.stateList = {}
  self.moveStateList = {}
  self.animator = nil
  self.animListen = nil
  self.attackTargetId = nil
  self.obj = nil
  self.curBlood = 10
  self.isRescued = false
  self.isInQueue = false
  self.isVisible = true
  self.queueIndex = 0
  self.moveBackSpeed = 1
  self.moveSpeed = 3.5
  self.attack = 1
  self.attackRadius = 10
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
end

function FollowPlayer:__delete()
end

function FollowPlayer:Create(attack, maxBlood, attackRadius)
  self.attack = attack
  self.curBlood = maxBlood
  self.attackRadius = attackRadius
  self.stateList[State.StopAttack] = FollowPlayerStopAttackState.New(self)
  self.stateList[State.Attack] = FollowPlayerAttackState.New(self)
  self.stateList[State.Dead] = FollowPlayerDeadState.New(self)
  self.moveStateList[MoveState.StopMove] = FollowPlayerStopMoveState.New(self)
  self.moveStateList[MoveState.Move] = FollowPlayerMoveState.New(self)
  self.moveStateList[MoveState.QueueMove] = FollowPlayerQueueMoveState.New(self)
  self.currStateIndex = State.StopAttack
  self.currMoveStateIndex = MoveState.StopMove
  self.currAnim = Anim.Idle
  self.currMoveAnim = MoveAnim.Stand
  self.obj = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/FollowPlayer.prefab")
  self.obj:completed("+", function()
    local gameObject = self.obj.gameObject
    local transform = gameObject.transform
    gameObject:SetActive(self.isVisible)
    self.gameObject = gameObject
    self.transform = transform
    local trigger = gameObject:GetComponent(typeof(CS.CitySpaceManTrigger))
    trigger.ObjectId = self.objId
    self.animator = transform:Find("A_soldie_ben/A_soldie@ben_skin"):GetComponent(typeof(CS.UnityEngine.Animator))
    self:SetRotation(self:GetRotation())
    self:SetPosition(self:GetPosition())
    self.currState = self.stateList[self.currStateIndex]
    self.currState:OnEnter()
    self.currMoveState = self.moveStateList[self.currMoveStateIndex]
    self.currMoveState:OnEnter()
  end)
end

function FollowPlayer:Destroy()
  if self.currState then
    self.currState:OnExit()
    self.currState = nil
  end
  if self.currMoveState then
    self.currMoveState:OnExit()
    self.currMoveState = nil
  end
  if self.obj then
    self.obj:Destroy()
    self.obj = nil
  end
end

function FollowPlayer:OnUpdate(deltaTime)
  if self.isRescued and not self.isInQueue then
    local target = self:GetAttackTarget()
    if target and target:GetCurBlood() > 0 then
      local distToTarget = Vector3.Distance(self:GetPosition(), target:GetPosition())
      if distToTarget > self.attackRadius then
        self.attackTargetId = nil
      end
    else
      self.attackTargetId = nil
    end
    if self.attackTargetId == nil then
      self.attackTargetId = self:DoSearchTarget()
    end
  end
  if self.currState then
    self.currState:OnUpdate(deltaTime)
  end
  if self.currMoveState then
    self.currMoveState:OnUpdate(deltaTime)
  end
end

function FollowPlayer:GetCurBlood()
  return self.curBlood
end

function FollowPlayer:BeAttack(hurt)
  self.curBlood = math.max(self.curBlood - hurt, 0)
  if self.curBlood <= 0 then
    self:Die()
  end
end

function FollowPlayer:GetPosition()
  return self.position
end

function FollowPlayer:SetPosition(pos)
  self.position = pos
  if self.transform then
    self.transform.position = pos
  end
end

function FollowPlayer:GetRotation()
  return self.rotation
end

function FollowPlayer:SetRotation(quaternion)
  self.rotation = quaternion
  if self.transform then
    self.transform.rotation = quaternion
  end
end

function FollowPlayer:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function FollowPlayer:GetForward()
  return self.rotation:Forward()
end

function FollowPlayer:Die()
  SetMoveState(self, MoveState.StopMove)
  SetState(self, State.Dead)
end

function FollowPlayer:StopMove()
  SetMoveState(self, MoveState.StopMove)
end

function FollowPlayer:StopAttack()
  SetState(self, State.StopAttack)
end

function FollowPlayer:PlayAnim(anim)
  self.currAnim = anim
  local triggerAnim = string.format("%s_%s", self.currMoveAnim, self.currAnim)
  for i, v in ipairs(AnimTriggerList) do
    self.animator:ResetTrigger(v)
  end
  self.animator:SetTrigger(triggerAnim)
end

function FollowPlayer:PlayMoveAnim(anim)
  self.currMoveAnim = anim
  local triggerAnim = string.format("%s_%s", self.currMoveAnim, self.currAnim)
  for i, v in ipairs(AnimTriggerList) do
    self.animator:ResetTrigger(v)
  end
  self.animator:SetTrigger(triggerAnim)
end

function FollowPlayer:DoSearchTarget()
  local pos = self:GetPosition()
  local layerMask = LayerMask.GetMask("Default")
  local radius = self.attackRadius
  local cnt = Physics.OverlapSphereNonAlloc(pos, radius, self.colliderArray, layerMask)
  if cnt <= 0 then
    return nil
  end
  local nearestId
  local minDist = 1000000
  cnt = math.min(20, cnt)
  for i = 1, cnt do
    local collider = self.colliderArray[i - 1]
    local trigger = collider:GetComponentInParent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil and trigger.ObjectId ~= 0 and trigger.ObjectId >= Const.ZombieIdMin and trigger.ObjectId <= Const.ZombieIdMax then
      local obj = self.battleLevel:GetObj(trigger.ObjectId)
      if obj ~= nil and 0 < obj:GetCurBlood() then
        local dist = Vector3.Distance(obj:GetPosition(), pos)
        if minDist > dist then
          minDist = dist
          nearestId = trigger.ObjectId
        end
      end
    end
  end
  return nearestId
end

function FollowPlayer:BeRescued()
  self.isRescued = true
end

function FollowPlayer:IsRescued()
  return self.isRescued
end

function FollowPlayer:Fire()
  self:OnAttackHitTarget()
end

function FollowPlayer:GetAttackTarget()
  return self.battleLevel:GetObj(self.attackTargetId)
end

function FollowPlayer:MoveAwayFromTarget()
  SetMoveState(self, MoveState.Move)
end

function FollowPlayer:MoveInQueue()
  if not self.isInQueue then
    self.isInQueue = true
    self.queueIndex = self.battleLevel:AddToFollowQueue(self)
  end
  SetMoveState(self, MoveState.QueueMove)
end

function FollowPlayer:GetAttackRadius()
  return self.attackRadius
end

function FollowPlayer:IsInQueue()
  return self.isInQueue
end

function FollowPlayer:GetPrePlayerInQueue()
  return self.battleLevel:GetFollowPlayerInQueue(self.queueIndex - 1)
end

function FollowPlayer:GetMoveBackSpeed()
  return self.moveBackSpeed
end

function FollowPlayer:GetMoveSpeed()
  return self.moveSpeed
end

function FollowPlayer:AttackTarget()
  SetState(self, State.Attack)
end

function FollowPlayer:OnAttackHitTarget()
  local target = self:GetAttackTarget()
  if target ~= nil and target:GetCurBlood() > 0 then
    target:BeAttack(self.attack)
  else
    self.attackTargetId = nil
  end
end

return FollowPlayer
