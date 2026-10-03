local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "building_level"
condition.params = {
  "number",
  "number",
  "number"
}

function condition.__Check(buildingId, pointerId, needLevel)
  for _, data in pairs(DataCenter.BuildManager.allBuilding) do
    local bBuildingId = buildingId < 0 or data.itemId == buildingId
    local bPointerId = pointerId < 0 or data.pointId == pointerId
    local bNeedLevel = data.level == needLevel
    if bBuildingId and bPointerId and bNeedLevel then
      return true
    end
  end
  return false
end

return condition
