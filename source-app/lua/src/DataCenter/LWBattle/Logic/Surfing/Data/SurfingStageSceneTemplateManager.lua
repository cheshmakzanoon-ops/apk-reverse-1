local SurfingStageSceneTemplateManager = BaseClass("SurfingStageSceneTemplateManager")
local SurfingStageSceneTemplate = require("DataCenter.LWBattle.Logic.Surfing.Data.SurfingStageSceneTemplate")

function SurfingStageSceneTemplateManager:__init()
  self.stageSceneTemps = {}
end

function SurfingStageSceneTemplateManager:__delete()
  self:Destroy()
end

function SurfingStageSceneTemplateManager:Destroy()
  for _, v in pairs(self.stageSceneTemps) do
    v:Delete()
  end
  self.stageSceneTemps = nil
end

function SurfingStageSceneTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.stageSceneTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.lw_surfing_stage_scene), intId)
    if line ~= nil then
      local item = SurfingStageSceneTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.stageSceneTemps[item.id] = item
      end
    end
  end
  return self.stageSceneTemps[intId]
end

return SurfingStageSceneTemplateManager
