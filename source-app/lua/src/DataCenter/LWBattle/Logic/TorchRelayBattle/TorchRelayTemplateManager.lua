local TorchRelayTemplateManager = BaseClass("TorchRelayTemplateManager")
local TorchRelayStageItemTemplate = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Config.TorchRelayStageItemTemplate")
local TorchRelayStageResourceTemplate = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Config.TorchRelayStageResourceTemplate")
local TorchRelayStageRandomTemplate = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Config.TorchRelayStageRandomTemplate")

function TorchRelayTemplateManager:__init()
  self.stageItemTemplatesDic = {}
  self.stageResourceTemplatesDic = {}
  self.stageRandomTemplatesDic = {}
end

function TorchRelayTemplateManager:__delete()
  self.stageItemTemplatesDic = nil
  self.stageResourceTemplatesDic = nil
  self.stageRandomTemplatesDic = nil
end

function TorchRelayTemplateManager:GetStageItemTemplate(id)
  if self.stageItemTemplatesDic[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.ACTIVITY_TORCH_RELAY_STAGE_ITEM, id)
    if rowData ~= nil then
      local template = TorchRelayStageItemTemplate.New()
      template:InitData(rowData)
      if template.id ~= nil then
        self.stageItemTemplatesDic[template.id] = template
      end
    end
  end
  return self.stageItemTemplatesDic[id]
end

function TorchRelayTemplateManager:GetStageResourceTemplate(id)
  if self.stageResourceTemplatesDic[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.ACTIVITY_TORCH_RELAY_STAGE_RESOURCE, id)
    if rowData ~= nil then
      local template = TorchRelayStageResourceTemplate.New()
      template:InitData(rowData)
      if template.id ~= nil then
        self.stageResourceTemplatesDic[template.id] = template
      end
    end
  end
  return self.stageResourceTemplatesDic[id]
end

function TorchRelayTemplateManager:GetStageRandomTemplate(id)
  if self.stageRandomTemplatesDic[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.ACTIVITY_TORCH_RELAY_STAGE_RANDOM, id)
    if rowData ~= nil then
      local template = TorchRelayStageRandomTemplate.New()
      template:InitData(rowData)
      if template.id ~= nil then
        self.stageRandomTemplatesDic[template.id] = template
      end
    end
  end
  return self.stageRandomTemplatesDic[id]
end

return TorchRelayTemplateManager
