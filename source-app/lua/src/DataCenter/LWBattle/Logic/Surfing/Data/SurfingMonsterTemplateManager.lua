local SurfingMonsterTemplateManager = BaseClass("SurfingMonsterTemplateManager")
local SurfingMonsterTemplate = require("DataCenter.LWBattle.Logic.Surfing.Data.SurfingMonsterTemplate")

function SurfingMonsterTemplateManager:__init()
  self.monsterTemps = {}
end

function SurfingMonsterTemplateManager:__delete()
  self:Destroy()
end

function SurfingMonsterTemplateManager:Destroy()
  for _, v in pairs(self.monsterTemps) do
    v:Delete()
  end
  self.monsterTemps = nil
end

function SurfingMonsterTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.monsterTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.lw_surfing_monster), intId)
    if line ~= nil then
      local item = SurfingMonsterTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.monsterTemps[item.id] = item
      end
    end
  end
  return self.monsterTemps[intId]
end

return SurfingMonsterTemplateManager
