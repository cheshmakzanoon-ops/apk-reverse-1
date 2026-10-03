local BaseBehaviourState = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BehaviourState.BHBaseBehaviourState")
local MonsterBehaviourStateStun = BaseClass("MonsterBehaviourStateStun", BaseBehaviourState)
local base = BaseBehaviourState

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function MonsterBehaviourStateStun:OnRegister(stateType, param)
  base.OnRegister(self, stateType, param)
end

function MonsterBehaviourStateStun:OnRemove()
  base.OnRemove(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateStun:OnEnter(param)
  base.OnEnter(self)
  self:OnExecute(param)
  self:ShowStateLog("[bounty hunter state] Enter MonsterBehaviourStateStun. uid: " .. self.itemEntity.monsterData.uuid)
end

function MonsterBehaviourStateStun:OnExecute(param)
  base.OnExecute(self)
  self.itemEntity:CrossFade("stun")
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

function MonsterBehaviourStateStun:OnExit()
  base.OnExit(self)
  self:StopAllTimerAndTween()
end

function MonsterBehaviourStateStun:StopAllTimerAndTween()
  if self.itemEntity then
    self.itemEntity:StopMove()
  end
end

MonsterBehaviourStateStun.__init = __init
MonsterBehaviourStateStun.__delete = __delete
return MonsterBehaviourStateStun
