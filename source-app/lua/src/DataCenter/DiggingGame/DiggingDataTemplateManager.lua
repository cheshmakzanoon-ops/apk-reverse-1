local DiggingDataTemplateManager = BaseClass("DiggingDataTemplateManager")
local LwSeasonDiggingGameTemplate = require("DataCenter.DiggingGame.LwSeasonDiggingGameTemplate")
local LwSeasonBlockTemplate = require("DataCenter.DiggingGame.LwSeasonBlockTemplate")

function DiggingDataTemplateManager:__init()
  self.diggingGameTemplateDic = nil
  self.diggingBlockTemplateDic = nil
end

function DiggingDataTemplateManager:__delete()
end

function DiggingDataTemplateManager:Startup()
end

function DiggingDataTemplateManager:GetConfigData(configId)
  if not self.diggingGameTemplateDic then
    self.diggingGameTemplateDic = {}
  end
  if not configId then
    return nil
  end
  if not self.diggingGameTemplateDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_DIGGING_GAME, configId)
    if line then
      local config = LwSeasonDiggingGameTemplate.New()
      config:UpdateData(line)
      self.diggingGameTemplateDic[configId] = config
    end
  end
  return self.diggingGameTemplateDic[configId]
end

function DiggingDataTemplateManager:GetConfigDataBlock(configId)
  if not self.diggingBlockTemplateDic then
    self.diggingBlockTemplateDic = {}
  end
  if not configId then
    return nil
  end
  if not self.diggingBlockTemplateDic[configId] then
    local line = LocalController:instance():getLine(TableName.LW_SEASON_BLOCK, configId)
    if line then
      local config = LwSeasonBlockTemplate.New()
      config:UpdateData(line)
      self.diggingBlockTemplateDic[configId] = config
    end
  end
  return self.diggingBlockTemplateDic[configId]
end

return DiggingDataTemplateManager
