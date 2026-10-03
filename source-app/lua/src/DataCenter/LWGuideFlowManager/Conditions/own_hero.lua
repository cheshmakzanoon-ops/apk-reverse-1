local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "own_hero"
condition.params = {"number"}

function condition.__Check(heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  return heroData ~= nil
end

return condition
