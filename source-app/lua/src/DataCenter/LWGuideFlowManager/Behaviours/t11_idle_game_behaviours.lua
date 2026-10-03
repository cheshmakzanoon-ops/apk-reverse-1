local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
behaviour.params = {
  {
    "number",
    "behaviourId"
  }
}

function behaviour:Begin()
  if self.behaviourId == Const.BehaviourId.OpenMain then
    DataCenter.T11IdleGameManager:OpenMain()
  elseif self.behaviourId == Const.BehaviourId.OpenIntroduction then
    DataCenter.T11IdleGameManager:OpenIntroduction()
  elseif self.behaviourId == Const.BehaviourId.OpenRule then
    DataCenter.T11IdleGameManager:OpenRule()
  end
  self.done = true
end

function behaviour:End()
end

return behaviour
