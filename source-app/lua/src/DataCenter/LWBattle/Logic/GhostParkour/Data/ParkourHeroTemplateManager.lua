local ParkourHeroTemplateManager = BaseClass("ParkourHeroTemplateManager")
local ParkourHeroTemplate = require("DataCenter.LWBattle.Logic.GhostParkour.Data.ParkourHeroTemplate")

function ParkourHeroTemplateManager:__init()
  self.heroTemps = {}
end

function ParkourHeroTemplateManager:__delete()
  self:Destroy()
end

function ParkourHeroTemplateManager:Destroy()
  for _, v in pairs(self.heroTemps) do
    v:Delete()
  end
  self.heroTemps = nil
end

function ParkourHeroTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.heroTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.parkour_hero), intId)
    if line ~= nil then
      local item = ParkourHeroTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.heroTemps[item.id] = item
      end
    end
  end
  return self.heroTemps[intId]
end

return ParkourHeroTemplateManager
