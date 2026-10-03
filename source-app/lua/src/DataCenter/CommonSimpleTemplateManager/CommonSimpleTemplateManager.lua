local CommonSimpleTemplateManager = BaseClass("CommonSimpleTemplateManager")

local function __init(self)
  self.typeTemplates = {}
  self.clsMap = {}
end

local function __delete(self)
  self.typeTemplates = nil
  self.clsMap = nil
end

local TABLE_TYPES = {
  [TableName.LW_SUMMONS] = "DataCenter.CommonSimpleTemplateManager.Templates.LWBattlePetTemplate"
}

local function GetClass(self, tableName)
  if self.clsMap[tableName] then
    return self.clsMap[tableName]
  else
    local path = TABLE_TYPES[tableName]
    if not path then
      Logger.LogError("CommonSimpleTemplateManager GetClass path is nil tableName:" .. tableName)
      return nil
    end
    local cls = require(path)
    if not cls then
      Logger.LogError("CommonSimpleTemplateManager GetClass cls is nil path:" .. path)
      return nil
    end
    self.clsMap[tableName] = cls
    return cls
  end
  return nil
end

function CommonSimpleTemplateManager:GetTemplate(tableName, id)
  local _id = tonumber(id)
  if not _id then
    Logger.LogError("CommonSimpleTemplateManager GetTemplate id is nil tableName:" .. tableName)
    return nil
  end
  local typeMap = self.typeTemplates[tableName]
  local template
  if typeMap == nil or typeMap[_id] == nil then
    local lineData = LocalController:instance():getLine(tableName, _id)
    if lineData == nil then
      Logger.LogError("CommonSimpleTemplateManager GetTemplate lineData is nil tableName:" .. tableName .. " id:" .. _id)
      return nil
    end
    local cls = GetClass(self, tableName)
    if not cls then
      Logger.LogError("CommonSimpleTemplateManager GetTemplate cls is nil tableName:" .. tableName)
      return nil
    end
    template = cls.New()
    template:InitData(lineData)
    if typeMap == nil then
      typeMap = {}
      self.typeTemplates[tableName] = typeMap
    end
  else
    template = typeMap[_id]
  end
  return template
end

CommonSimpleTemplateManager.__init = __init
CommonSimpleTemplateManager.__delete = __delete
return CommonSimpleTemplateManager
