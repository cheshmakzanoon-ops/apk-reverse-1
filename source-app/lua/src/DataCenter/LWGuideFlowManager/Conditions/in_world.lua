local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "in_world"

function condition.__Check()
  return CS.SceneManager:IsInWorld()
end

return condition
