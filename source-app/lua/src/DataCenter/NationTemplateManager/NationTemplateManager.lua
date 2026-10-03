local NationTemplateManager = BaseClass("NationTemplateManager")
local NationTemplate = require("DataCenter.NationTemplateManager.NationTemplate")

local function __init(self)
  self.nationsDic = nil
  self.nationFlags = nil
  self.defaultNation = nil
end

local function __delete(self)
  self.nationsDic = nil
  self.nationFlags = nil
  self.defaultNation = nil
end

local function InitNationDic(self)
  self.nationsDic = {}
  self.nationFlags = {}
  LocalController:instance():visitTable(TableName.NationConf, function(id, lineData)
    local item = NationTemplate.New()
    item:ParseData(lineData)
    self.nationsDic[item.nation] = item
    if not self.defaultNation then
      self.defaultNation = item
    end
    table.insert(self.nationFlags, item.flag)
  end)
  if self.nationsDic[DefaultNation] then
    self.defaultNation = self.nationsDic[DefaultNation]
  end
end

local function GetAllNationsList(self)
  if not self.nationsDic then
    self:InitNationDic()
  end
  return table.values(self.nationsDic)
end

local function GetNationTemplate(self, nation)
  if not self.nationsDic then
    self:InitNationDic()
  end
  nation = string.IsNullOrEmpty(nation) and DefaultNation or nation
  local template = self.nationsDic[nation]
  template = template or self.defaultNation
  return template
end

local function GetAllNationFlagList(self)
  if not self.nationsDic then
    self:InitNationDic()
  end
  return self.nationFlags
end

NationTemplateManager.__init = __init
NationTemplateManager.__delete = __delete
NationTemplateManager.InitNationDic = InitNationDic
NationTemplateManager.GetAllNationsList = GetAllNationsList
NationTemplateManager.GetNationTemplate = GetNationTemplate
NationTemplateManager.GetAllNationFlagList = GetAllNationFlagList
return NationTemplateManager
