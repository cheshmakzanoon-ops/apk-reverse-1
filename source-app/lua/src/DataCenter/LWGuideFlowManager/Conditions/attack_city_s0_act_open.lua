local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "attack_city_s0_act_open"

function condition.__Check()
  return DataCenter.LoginGuideManager:GetAttackCityS0ActIsOpen()
end

return condition
