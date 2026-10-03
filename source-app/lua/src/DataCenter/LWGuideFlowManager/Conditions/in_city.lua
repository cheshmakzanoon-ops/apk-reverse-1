local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "in_city"

function condition.__Check()
  return CS.SceneManager:IsInCity()
end

return condition
