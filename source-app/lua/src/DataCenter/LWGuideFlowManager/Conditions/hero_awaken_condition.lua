local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "hero_awaken_condition"
condition.params = {"number"}

function condition.__Check(conditionId)
  if DataCenter.HeroAwakenDataManager:IsHeroAwakenFunctionOn() and conditionId == HeroUtils.HeroAwakenGuideFlowCondition.Condition_1 then
    return true
  end
  return false
end

return condition
