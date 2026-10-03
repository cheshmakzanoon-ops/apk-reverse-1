local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "window_open"
condition.params = {"string"}

function condition.__Check(windowName)
  if string.IsNullOrEmpty(windowName) then
    return false
  end
  return UIManager:GetInstance():IsWindowOpen(windowName)
end

return condition
