local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "building_build_state"
condition.params = {"number", "number"}

function condition.__Check(buildingId, checkState)
  local curBuildState = DataCenter.BuildManager:GetBuildState(buildingId)
  return curBuildState == checkState
end

return condition
