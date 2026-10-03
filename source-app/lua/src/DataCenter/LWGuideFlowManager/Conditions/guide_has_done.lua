local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "guide_has_done"
condition.params = {"number"}

function condition.__Check(checkId)
  return DataCenter.LWGuideFlowManager:ReadDone(checkId)
end

return condition
