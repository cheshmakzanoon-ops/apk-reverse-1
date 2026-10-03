local BHBaseBehaviourState = BaseClass("BHBaseBehaviourState")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")

local function __init(self)
  self.itemEntity = nil
  self.stateType = nil
end

local function __delete(self)
  self.itemEntity = nil
  self.stateType = nil
  self:StopAllTimerAndTween()
end

function BHBaseBehaviourState:OnRegister(stateType, param)
  self.stateType = stateType
  self.itemEntity = param
end

function BHBaseBehaviourState:OnRemove()
  self:StopAllTimerAndTween()
end

function BHBaseBehaviourState:OnEnter(param)
end

function BHBaseBehaviourState:OnExecute(param)
end

function BHBaseBehaviourState:OnExit()
end

function BHBaseBehaviourState:StopAllTimerAndTween()
end

function BHBaseBehaviourState:CheckIsCanExitState(nextState)
  return true
end

function BHBaseBehaviourState:ShowStateLog(info)
  if CS.UnityEngine.Application.isEditor and Const.IS_SHOW_BEHAVIOUR_DEBUG_LOG then
    Logger.LogCustom(string.format("[bounty hunter] %s", info))
  end
end

BHBaseBehaviourState.__init = __init
BHBaseBehaviourState.__delete = __delete
return BHBaseBehaviourState
