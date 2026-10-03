local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "workers_on_copter"
condition.params = {"number", "bool"}

function condition.__Check(needNum, equal)
  local num = DataCenter.GainWorkerManager:GetIsHavePveWorker()
  if num == nil then
    return false
  end
  if equal then
    return num == needNum
  else
    return needNum <= num
  end
end

return condition
