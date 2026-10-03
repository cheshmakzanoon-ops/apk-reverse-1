local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "feature_unlocked"
condition.params = {"number"}

function condition.__Check(functionId)
  local unlocked = DataCenter.LWFunctionUnlockManager:CheckCanShow(functionId)
  return unlocked
end

return condition
