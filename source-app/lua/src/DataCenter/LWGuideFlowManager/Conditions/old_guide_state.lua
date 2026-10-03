local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "old_guide_state"
condition.params = {"number"}

function condition.__Check(guideState)
  return DataCenter.LWGuideManager.curGuideId == guideState
end

return condition
