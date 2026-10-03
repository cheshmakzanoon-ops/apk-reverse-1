local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "hero_in_squad"
condition.params = {"number", "number"}

function condition.__Check(squadIdx, heroId)
  local squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, squadIdx)
  if squadData == nil then
    return false
  end
  for _, heroUuid in pairs(squadData.localIndexToHeroDic) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil and heroData.heroId == heroId then
      return true
    end
  end
  return false
end

return condition
