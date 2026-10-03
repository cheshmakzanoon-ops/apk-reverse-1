local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "count_of_buildings"
condition.params = {
  "number",
  "number",
  "number"
}

function condition.__Check(buildingId, checkCount, comparisonType)
  local count = 0
  for _, building in pairs(DataCenter.BuildManager.allBuilding) do
    if building.itemId == buildingId then
      count = count + 1
    end
  end
  return condition:CompareNumber(count, checkCount, comparisonType)
end

return condition
