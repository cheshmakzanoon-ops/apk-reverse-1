local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "hero_equip_recommend_open"

function condition.__Check()
  return DataCenter.EquipRecommendManager:IsFunctionOpen()
end

return condition
