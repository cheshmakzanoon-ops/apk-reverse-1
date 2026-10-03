local DetectEventTemplateManager = BaseClass("DetectEventTemplateManager")

local function __init(self)
  self.detectEventTemplateDic = {}
end

local function __delete(self)
  self.detectEventTemplateDic = nil
end

local function GetDetectEventTemplate(self, id)
  if self.detectEventTemplateDic[id] == nil then
    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DetectEvent), id)
    if lineData ~= nil then
      local item = DetectEventTemplate.New()
      item:InitData(lineData)
      if item.id ~= nil then
        self.detectEventTemplateDic[item.id] = item
      end
    end
  end
  return self.detectEventTemplateDic[id]
end

DetectEventTemplateManager.__init = __init
DetectEventTemplateManager.__delete = __delete
DetectEventTemplateManager.GetDetectEventTemplate = GetDetectEventTemplate
return DetectEventTemplateManager
