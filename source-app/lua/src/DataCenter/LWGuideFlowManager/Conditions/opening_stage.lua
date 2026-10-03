local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "opening_stage"
condition.params = {"number"}

function condition.__Check(checkStageId)
  return DataCenter.LWOpeningStageManager:IsStageDone(checkStageId)
end

return condition
