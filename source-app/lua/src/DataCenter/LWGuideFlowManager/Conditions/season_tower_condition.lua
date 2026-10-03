local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "season_tower_condition"
condition.params = {"number"}

function condition.__Check(conditionId)
  if conditionId == SeasonTowerConfig.GuideData.ConditionId.Base and DataCenter.LWSeasonTowerManager:IsShowEntrance() and not DataCenter.LWSeasonTowerManager:IsPreview() then
    return true
  end
  return false
end

return condition
