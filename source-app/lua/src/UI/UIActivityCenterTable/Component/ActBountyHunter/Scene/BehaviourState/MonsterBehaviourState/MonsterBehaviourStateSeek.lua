local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateSeek = BaseClass("MonsterBehaviourStateSeek", BaseBehaviourState)
local base = BaseBehaviourState
local SEEK_TIME = 10

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateSeek:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateSeek:OnRemove()
  base.OnRemove(self)
end

function MonsterBehaviourStateSeek:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateSeek. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateSeek:OnExecute(param)
  base.OnExecute(self)
  if not (self.itemEntity and self.itemEntity.transform) or not param then
    return
  end
  self:StopAllTimerAndTween()
  local movePos = param + Vector3.up * self.itemEntity.transform.localPosition.y
  local isFaceTarget = true
  self.itemEntity:MoveToTargetPos(movePos, SEEK_TIME, "run", isFaceTarget, function()
    self.itemEntity:StopMove()
  end)
end

function MonsterBehaviourStateSeek:OnExit()
  base.OnExit(self)
end

function MonsterBehaviourStateSeek:StopAllTimerAndTween()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

MonsterBehaviourStateSeek.__init = __init
MonsterBehaviourStateSeek.__delete = __delete
return MonsterBehaviourStateSeek
