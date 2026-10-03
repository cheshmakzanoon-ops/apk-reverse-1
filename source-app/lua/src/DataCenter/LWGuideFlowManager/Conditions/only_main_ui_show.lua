local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "only_main_ui_show"
condition.params = {}

function condition.__Check()
  return UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true)
end

return condition
