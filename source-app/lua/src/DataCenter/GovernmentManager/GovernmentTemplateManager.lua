local GovernmentTemplateManager = BaseClass("GovernmentTemplateManager")
local GovernmentTemplate = require("DataCenter.GovernmentManager.GovernmentTemplate")

function GovernmentTemplateManager:__init()
  self.templateDic = nil
  self.type2TemplateList = nil
  self.season2Type2TemplateList = nil
  self.id2UniqueOrder = nil
  self.leaders = nil
  self.vicePresidents = {}
  self.destroyerKings = {}
end

function GovernmentTemplateManager:__delete()
  self.templateDic = nil
  self.type2TemplateList = nil
  self.season2Type2TemplateList = nil
  self.id2UniqueOrder = nil
  self.leaders = nil
  self.destroyerKings = nil
end

function GovernmentTemplateManager:InitAllTemplate()
  self.templateDic = {}
  self.type2TemplateList = {}
  self.season2Type2TemplateList = {}
  self.id2UniqueOrder = {}
  self.leaders = {}
  LocalController:instance():visitTable(TableName.Government, function(id, lineData)
    local item = GovernmentTemplate.New()
    item:InitData(lineData)
    self.templateDic[item.id] = item
    if item.season_type == nil then
      if self.type2TemplateList[item.type] == nil then
        self.type2TemplateList[item.type] = {}
      end
      table.insert(self.type2TemplateList[item.type], item)
    else
      if self.season2Type2TemplateList[item.season_type] == nil then
        self.season2Type2TemplateList[item.season_type] = {}
      end
      if self.season2Type2TemplateList[item.season_type][item.type] == nil then
        self.season2Type2TemplateList[item.season_type][item.type] = {}
      end
      table.insert(self.season2Type2TemplateList[item.season_type][item.type], item)
    end
    self.id2UniqueOrder[item.id] = item.uniqueOrder
    if item.order == 0 then
      self.leaders[item.id] = item
    end
    if item.supreme_president_power then
      table.insert(self.vicePresidents, item)
    end
    if item.type == GovOfficialType.Destroyer and (self.destroyerKings[item.season_type] == nil or self.destroyerKings[item.season_type].order > item.order) then
      self.destroyerKings[item.season_type] = item
    end
  end)
  for _, v in pairs(self.type2TemplateList) do
    table.sort(v, function(a, b)
      return a.order < b.order
    end)
  end
  for _, v in pairs(self.season2Type2TemplateList) do
    for _, v2 in pairs(v) do
      table.sort(v2, function(a, b)
        return a.order < b.order
      end)
    end
  end
end

function GovernmentTemplateManager:GetAllTemplate()
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic
end

function GovernmentTemplateManager:GetTemplate(id)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.templateDic[toInt(id)]
end

function GovernmentTemplateManager:GetTemplateByGroupAndOrder(group, order)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  for _, v in pairs(self.templateDic) do
    if v ~= nil and v.group == group and v.order == order then
      return v
    end
  end
  return nil
end

function GovernmentTemplateManager:GetTemplateByTitleName(titleName)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  for _, v in pairs(self.templateDic) do
    if v ~= nil and v.title_name == titleName then
      return v
    end
  end
  return nil
end

function GovernmentTemplateManager:IsConqueror(id)
  local template = self:GetTemplate(id)
  return template and template.type == GovOfficialType.Conquer
end

function GovernmentTemplateManager:GetTemplateName(id)
  local template = self:GetTemplate(id)
  if template ~= nil then
    return CS.GameEntry.Localization:GetString(template.name)
  end
  return ""
end

function GovernmentTemplateManager:GetTemplatesSorted(ids)
  local templates = {}
  for _, v in ipairs(ids) do
    local template = self:GetTemplate(v)
    if template ~= nil then
      table.insert(templates, template)
    end
  end
  table.sort(templates, function(a, b)
    if a.type == b.type then
      return a.order < b.order
    end
    if a.type == GovOfficialType.Center or b.type == GovOfficialType.Outpost then
      return true
    elseif b.type == GovOfficialType.Center or a.type == GovOfficialType.Outpost then
      return false
    end
    return a.id > b.id
  end)
  return templates
end

function GovernmentTemplateManager:GetTemplatesByType(type, seasonSubType)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  if seasonSubType ~= nil and self.season2Type2TemplateList[seasonSubType] and self.season2Type2TemplateList[seasonSubType][type] then
    return self.season2Type2TemplateList[seasonSubType][type]
  end
  return self.type2TemplateList[type] or {}
end

function GovernmentTemplateManager:GetUniqueOrder()
  if self.id2UniqueOrder == nil then
    self:InitAllTemplate()
  end
  return self.id2UniqueOrder
end

function GovernmentTemplateManager:IsLeader(id)
  if self.leaders == nil then
    self:InitAllTemplate()
  end
  return self.leaders[id]
end

function GovernmentTemplateManager:GetLeaderByType(type, seasonSubType)
  if self.leaders == nil then
    self:InitAllTemplate()
  end
  for _, v in pairs(self.leaders) do
    if v.type == type and seasonSubType == v.season_type then
      return v
    end
  end
  for _, v in pairs(self.leaders) do
    if v.type == type and v.season_type == nil then
      return v
    end
  end
end

function GovernmentTemplateManager:GetVicePresidents()
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.vicePresidents
end

function GovernmentTemplateManager:GetDestroyerKingConfig(seasonSubType)
  if self.templateDic == nil then
    self:InitAllTemplate()
  end
  return self.destroyerKings[seasonSubType]
end

return GovernmentTemplateManager
