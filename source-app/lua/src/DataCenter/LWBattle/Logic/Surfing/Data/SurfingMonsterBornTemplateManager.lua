local SurfingMonsterBornTemplateManager = BaseClass("SurfingMonsterBornTemplateManager")
local SurfingMonsterBornTemplate = require("DataCenter.LWBattle.Logic.Surfing.Data.SurfingMonsterBornTemplate")

function SurfingMonsterBornTemplateManager:__init()
  self.monsterBornTemps = {}
end

function SurfingMonsterBornTemplateManager:__delete()
  self:Destroy()
end

function SurfingMonsterBornTemplateManager:Destroy()
  for _, v in pairs(self.monsterBornTemps) do
    v:Delete()
  end
  self.monsterBornTemps = nil
end

function SurfingMonsterBornTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.monsterBornTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.lw_surfing_monster_born), intId)
    if line ~= nil then
      local item = SurfingMonsterBornTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.monsterBornTemps[item.id] = item
      end
    end
  end
  return self.monsterBornTemps[intId]
end

return SurfingMonsterBornTemplateManager
