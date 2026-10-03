local SingleMapJunkTemplateManager = BaseClass("SingleMapJunkTemplateManager")

local function __init(self)
  self.tempDict = nil
end

local function __delete(self)
  self.tempDict = nil
end

local function InitAllTemplate(self)
  self.tempDict = {}
  LocalController:instance():visitTable(TableName.APS_SINGLEMAP_JUNK, function(id, lineData)
    local item = SingleMapJunkTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil then
      self.tempDict[item.id] = item
    end
  end)
end

local function GetTemplate(self, id)
  if self.tempDict == nil then
    self:InitAllTemplate()
  end
  return self.tempDict[tonumber(id)]
end

SingleMapJunkTemplateManager.__init = __init
SingleMapJunkTemplateManager.__delete = __delete
SingleMapJunkTemplateManager.InitAllTemplate = InitAllTemplate
SingleMapJunkTemplateManager.GetTemplate = GetTemplate
return SingleMapJunkTemplateManager
