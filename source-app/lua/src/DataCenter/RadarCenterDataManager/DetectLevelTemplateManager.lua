local DetectLevelTemplateManager = BaseClass("DetectLevelTemplateManager")

local function __init(self)
  self.DetectLevelTemplateDic = nil
end

local function __delete(self)
  self.DetectLevelTemplateDic = nil
end

local function InitAllTemplate(self)
  self.DetectLevelTemplateDic = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), function(id, lineData)
    local item = DetectLevelTemplate.New()
    item:InitData(lineData)
    self.DetectLevelTemplateDic[item.id] = item
  end)
end

local function GetAllTemplate(self)
  if self.DetectLevelTemplateDic == nil then
    self:InitAllTemplate()
  end
  return self.DetectLevelTemplateDic
end

local function GetDetectLevelTemplate(self, id)
  if self.DetectLevelTemplateDic == nil then
    self:InitAllTemplate()
  end
  return self.DetectLevelTemplateDic[id]
end

local function GetMaxLevel(self)
  if self.DetectLevelTemplateDic == nil then
    self:InitAllTemplate()
  end
  return #self.DetectLevelTemplateDic
end

DetectLevelTemplateManager.__init = __init
DetectLevelTemplateManager.__delete = __delete
DetectLevelTemplateManager.InitAllTemplate = InitAllTemplate
DetectLevelTemplateManager.GetAllTemplate = GetAllTemplate
DetectLevelTemplateManager.GetDetectLevelTemplate = GetDetectLevelTemplate
DetectLevelTemplateManager.GetMaxLevel = GetMaxLevel
return DetectLevelTemplateManager
