local LWHeroEnergyLevelUpTemplateManager = BaseClass("LWHeroEnergyLevelUpTemplateManager")
local LWHeroEnergyLevelUpTemplate = require("DataCenter.LWHeroEnergyLevelUp.LWHeroEnergyLevelUpTemplate")

function LWHeroEnergyLevelUpTemplateManager:__init()
  self.templateMap = {}
end

function LWHeroEnergyLevelUpTemplateManager:__delete()
end

function LWHeroEnergyLevelUpTemplateManager:GetTemplate(id)
  id = tonumber(id)
  if table.containsKey(self.templateMap, id) then
    return self.templateMap[id]
  end
  local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_hero_energy_levelup), id)
  if lineData == nil then
    Logger.LogError("lw_hero_energy_levelup GetTemplate lineData is nil id:" .. id)
    return nil
  end
  local template = LWHeroEnergyLevelUpTemplate.New()
  template:InitData(lineData)
  self.templateMap[id] = template
  return template
end

return LWHeroEnergyLevelUpTemplateManager
