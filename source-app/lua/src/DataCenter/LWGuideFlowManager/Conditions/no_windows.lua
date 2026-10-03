local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "no_windows"

function condition.__Check()
  return UIManager:GetInstance():GetStackWindowCount() == 0
end

return condition
