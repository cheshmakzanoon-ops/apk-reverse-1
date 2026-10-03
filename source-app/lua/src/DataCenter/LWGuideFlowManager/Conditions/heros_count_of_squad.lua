local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "heros_count_of_squad"
condition.params = {"number", "number"}

function condition.__Check(squadIdx, needCount)
  local squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, squadIdx)
  local count = 0
  if squadData ~= nil then
    for _, _ in pairs(squadData.localIndexToHeroDic) do
      count = count + 1
    end
  end
  return needCount <= count
end

return condition
