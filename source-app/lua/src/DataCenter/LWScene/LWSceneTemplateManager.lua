local LWSceneTemplateManager = BaseClass("LWSceneTemplateManager")
local LWSceneTemplate = require("DataCenter.LWScene.LWSceneTemplate")

function LWSceneTemplateManager:__init()
  self.sceneTemps = {}
end

function LWSceneTemplateManager:__delete()
  self:Destroy()
end

function LWSceneTemplateManager:Destroy()
  for _, v in pairs(self.sceneTemps) do
    v:Delete()
  end
  self.sceneTemps = nil
end

function LWSceneTemplateManager:GetTemplate(id)
  if id == nil then
    Logger.LogError("id is nil")
    return
  end
  local intId = toInt(id)
  if self.sceneTemps[intId] == nil and 0 < intId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), intId)
    if line ~= nil then
      local item = LWSceneTemplate.New()
      item:InitConfig(line)
      if item.id ~= nil then
        self.sceneTemps[item.id] = item
      end
    end
  end
  return self.sceneTemps[intId]
end

return LWSceneTemplateManager
