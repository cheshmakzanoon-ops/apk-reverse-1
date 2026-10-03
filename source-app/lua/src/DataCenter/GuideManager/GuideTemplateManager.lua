local GuideTemplateManager = BaseClass("GuideTemplateManager")

local function __init(self)
  self.guideTemplateDic = {}
  self.useTabName = nil
  self.landLockAlterDict = {}
end

local function __delete(self)
  self.guideTemplateDic = nil
  self.useTabName = nil
  self.landLockAlterDict = nil
end

local function InitAllTemplate(self, triggerTable)
  if triggerTable == nil then
    triggerTable = {}
  end
  LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
    local item = GuideTemplate.New()
    item:InitData(lineData)
    if item.id ~= nil then
      self.guideTemplateDic[item.id] = item
      if triggerTable[item.triggertype] == nil then
        triggerTable[item.triggertype] = {}
      end
      if item.triggerpara ~= nil and item.triggerpara ~= "" then
        triggerTable[item.triggertype][item.triggerpara] = item.id
      end
      if item.type == GuideType.LandLockChangeModel then
        local landLockId = tonumber(item.para1)
        local guideId = item.id
        local alter = item.para2
        if self.landLockAlterDict[landLockId] == nil then
          self.landLockAlterDict[landLockId] = {}
        end
        table.insert(self.landLockAlterDict[landLockId], {guideId = guideId, alter = alter})
      end
    end
  end)
end

local function GetGuideTemplate(self, id)
  if self.guideTemplateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(self:GetTableName(), tostring(id))
    if oneTemplate ~= nil then
      local item = GuideTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.guideTemplateDic[item.id] = item
      end
    end
  end
  return self.guideTemplateDic[tonumber(id)]
end

local function GetTableName(self)
  if self.useTabName == nil then
    self.useTabName = LuaEntry.Player:GetABTestTableName(TableName.Guide)
  end
  return self.useTabName
end

local function GetLandLockAlters(self, landLockId)
  return self.landLockAlterDict[landLockId]
end

GuideTemplateManager.__init = __init
GuideTemplateManager.__delete = __delete
GuideTemplateManager.InitAllTemplate = InitAllTemplate
GuideTemplateManager.GetGuideTemplate = GetGuideTemplate
GuideTemplateManager.GetTableName = GetTableName
GuideTemplateManager.GetLandLockAlters = GetLandLockAlters
return GuideTemplateManager
