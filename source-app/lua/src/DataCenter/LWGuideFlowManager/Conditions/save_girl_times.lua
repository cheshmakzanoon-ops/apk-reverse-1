local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "save_girl_times"
condition.params = {"number", "number"}

function condition.__Check(checkTimes, comparisonType)
  local saveTimes = DataCenter.LWSaveGirlManager:GetSaveTimes()
  return condition:CompareNumber(saveTimes, checkTimes, comparisonType)
end

return condition
