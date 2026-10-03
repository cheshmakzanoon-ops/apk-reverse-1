local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "squad_slot_empty"
condition.params = {"number", "number"}

function condition.__Check(squadIdx, slotIdx)
  local squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, squadIdx)
  if squadData == nil then
    return true
  end
  return squadData.localIndexToHeroDic[slotIdx] == nil
end

return condition
