local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "building_state"
condition.params = {
  "number",
  "number",
  "number"
}

function condition.__Check(buildingId, pointerId, checkState)
  for _, data in pairs(DataCenter.BuildManager.allBuilding) do
    local bBuildingId = buildingId < 0 or data.itemId == buildingId
    local bPointerId = pointerId < 0 or data.pointId == pointerId
    local bCheckState = false
    if checkState == 0 then
      bCheckState = data.state == BuildingStateType.Normal and data.level == 0
    elseif checkState == 1 then
      bCheckState = data.state == BuildingStateType.Normal and 0 < data.level
    elseif checkState == 2 then
      bCheckState = data.state == BuildingStateType.Upgrading and data:IsUpgradeFinish()
    elseif checkState == 3 then
      bCheckState = data.state == BuildingStateType.Upgrading and data:IsUpgrading()
    end
    if bBuildingId and bPointerId and bCheckState then
      return true
    end
  end
  return false
end

return condition
