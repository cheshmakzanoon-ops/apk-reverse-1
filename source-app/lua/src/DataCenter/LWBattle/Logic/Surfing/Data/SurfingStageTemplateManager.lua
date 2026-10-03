local SurfingStageTemplateManager = BaseClass("SurfingStageTemplateManager")
local SurfingStageTemplate = require("DataCenter.LWBattle.Logic.Surfing.Data.SurfingStageTemplate")

function SurfingStageTemplateManager:__init()
  self.stageTemps = {}
end

function SurfingStageTemplateManager:__delete()
  self:Destroy()
end

function SurfingStageTemplateManager:Destroy()
  for _, v in pairs(self.stageTemps) do
    v:Delete()
  end
  self.stageTemps = nil
end

function SurfingStageTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.stageTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.lw_surfing_stage), intId)
    if line ~= nil then
      local item = SurfingStageTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.stageTemps[item.id] = item
      end
    end
  end
  return self.stageTemps[intId]
end

return SurfingStageTemplateManager
