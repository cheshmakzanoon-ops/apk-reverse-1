local ParkourGhostNpcTemplateManager = BaseClass("ParkourGhostNpcTemplateManager")
local ParkourGhostNpcTemplate = require("DataCenter.LWBattle.Logic.GhostParkour.Data.ParkourGhostNpcTemplate")

function ParkourGhostNpcTemplateManager:__init()
  self.npcTemps = {}
end

function ParkourGhostNpcTemplateManager:__delete()
  self:Destroy()
end

function ParkourGhostNpcTemplateManager:Destroy()
  for _, v in pairs(self.npcTemps) do
    v:Delete()
  end
  self.npcTemps = nil
end

function ParkourGhostNpcTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.npcTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.parkour_ghost_npc), intId)
    if line ~= nil then
      local item = ParkourGhostNpcTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.npcTemps[item.id] = item
      end
    end
  end
  return self.npcTemps[intId]
end

return ParkourGhostNpcTemplateManager
