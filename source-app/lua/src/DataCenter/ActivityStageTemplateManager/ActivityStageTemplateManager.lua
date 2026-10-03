local ActivityStageTemplateManager = BaseClass("ActivityStageTemplateManager")
local ActivityStageTemplate = require("DataCenter.ActivityStageTemplateManager.ActivityStageTemplate")

local function __init(self)
  self.templateDic = nil
end

local function __delete(self)
  self.templateDic = nil
end

function ActivityStageTemplateManager:InitAllTemplate()
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.Activity_Stage, function(id, lineData)
    local item = ActivityStageTemplate.New()
    item:InitData(lineData)
    self.templateDic[tostring(item.id)] = item
  end)
end

function ActivityStageTemplateManager:GetTemplate(stageId)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic[tostring(stageId)]
end

function ActivityStageTemplateManager:GetTemplateByStageType(stageType)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  if self.templateDic ~= nil then
    local numStageType = tonumber(stageType)
    for _, v in pairs(self.templateDic) do
      if v ~= nil and v.stage == numStageType then
        return v
      end
    end
  end
  return nil
end

ActivityStageTemplateManager.__init = __init
ActivityStageTemplateManager.__delete = __delete
return ActivityStageTemplateManager
