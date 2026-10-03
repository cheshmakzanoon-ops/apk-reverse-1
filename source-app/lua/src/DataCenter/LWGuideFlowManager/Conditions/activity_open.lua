local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "activity_open"
condition.params = {"number"}

function condition.__Check(activityId)
  local isOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(nil, activityId) or false
  return isOpen
end

return condition
