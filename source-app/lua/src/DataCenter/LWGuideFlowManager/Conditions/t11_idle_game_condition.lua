local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
condition.name = "t11_idle_game_condition"
condition.params = {"number"}

function condition.__Check(conditionId)
  if conditionId == Const.ConditionId.Base and DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn() then
    return true
  end
  return false
end

return condition
