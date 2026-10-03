local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "decoration_recommend_on"

function condition.__Check(conditionId)
  return DataCenter.DecorationRecommendManager:IsFunctionOn()
end

return condition
