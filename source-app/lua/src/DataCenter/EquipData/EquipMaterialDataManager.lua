local EquipMaterialDataManager = BaseClass("EquipMaterialDataManager")
local EquipMaterialTemplate = require("DataCenter.EquipData.EquipMaterialTemplate")

local function __init(self)
  self.templateDict = {}
  self.categoryDict = {}
  self:InitAllTemplate()
end

local function __delete(self)
  self.templateDict = nil
  self.categoryDict = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.LW_Equip_Material, function(id, lineData)
    local template = EquipMaterialTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    if self.categoryDict[template.category] == nil then
      self.categoryDict[template.category] = {}
    end
    table.insert(self.categoryDict[template.category], template)
  end)
end

local function GetTemplate(self, id)
  return self.templateDict[id]
end

local function GetMaterialResourceItemId(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return 0
  end
  return template.resourceItem_Id
end

local function GetAllMaterialTemplate(self)
  local list = {}
  for category, array in pairs(self.categoryDict) do
    if list[category] == nil then
      list[category] = {}
    end
    for _, template in pairs(array) do
      table.insert(list[category], template.id)
    end
  end
  return list
end

local function GetAllMaterialPlayerHave(self, containEmptyCategory)
  local list = {}
  for category, array in pairs(self.categoryDict) do
    if containEmptyCategory and list[category] == nil then
      list[category] = {}
    end
    for _, template in pairs(array) do
      local count = DataCenter.ResourceItemDataManager:GetCountByItemId(template.resourceItem_Id)
      if 0 < count then
        if not containEmptyCategory and list[category] == nil then
          list[category] = {}
        end
        table.insert(list[category], {
          id = template.id,
          count = count
        })
      end
    end
  end
  return list
end

local function GetMaterialByCategoryAndQuality(self, category, quality)
  local array = self.categoryDict[category]
  if array == nil then
    return nil
  end
  for _, template in pairs(array) do
    if template.quality == quality then
      return template
    end
  end
  return nil
end

local function GetNextQualityMaterial(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return nil
  end
  local nextQuality = template.quality + 1
  if 6 < nextQuality then
    return nil
  end
  local nextQualityMaterial = self:GetMaterialByCategoryAndQuality(template.category, nextQuality)
  return nextQualityMaterial
end

local function GetLastQualityMaterial(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return nil
  end
  local lastQuality = template.quality - 1
  if lastQuality < 1 then
    return nil
  end
  local lastQualityMaterial = self:GetMaterialByCategoryAndQuality(template.category, lastQuality)
  return lastQualityMaterial
end

local function GetMaterialName(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return ""
  end
  return template.name
end

local function GetMaterialDesc(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return ""
  end
  return template.desc
end

local function GetMaterialIcon(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return ""
  end
  return template.icon
end

local function GetMaterialQuality(self, materialId)
  local template = self:GetTemplate(materialId)
  if template == nil then
    return 0
  end
  return template.quality
end

local function GetMaterialCategoryName(category)
  if category == 1 then
    return 430713
  elseif category == 2 then
    return 430714
  elseif category == 3 then
    return 430715
  elseif category == 4 then
    return 430716
  end
  return 430713
end

local function GetCountById(self, id)
  local template = self:GetTemplate(id)
  if template == nil then
    return 0
  end
  return DataCenter.ResourceItemDataManager:GetCountByItemId(template.resourceItem_Id)
end

local function GetMaterialCategory(self, id)
  local template = self:GetTemplate(id)
  if template == nil then
    return 1
  end
  return template.category
end

EquipMaterialDataManager.__init = __init
EquipMaterialDataManager.__delete = __delete
EquipMaterialDataManager.InitAllTemplate = InitAllTemplate
EquipMaterialDataManager.GetTemplate = GetTemplate
EquipMaterialDataManager.GetMaterialResourceItemId = GetMaterialResourceItemId
EquipMaterialDataManager.GetAllMaterialTemplate = GetAllMaterialTemplate
EquipMaterialDataManager.GetAllMaterialPlayerHave = GetAllMaterialPlayerHave
EquipMaterialDataManager.GetMaterialByCategoryAndQuality = GetMaterialByCategoryAndQuality
EquipMaterialDataManager.GetLastQualityMaterial = GetLastQualityMaterial
EquipMaterialDataManager.GetNextQualityMaterial = GetNextQualityMaterial
EquipMaterialDataManager.GetMaterialName = GetMaterialName
EquipMaterialDataManager.GetMaterialDesc = GetMaterialDesc
EquipMaterialDataManager.GetMaterialIcon = GetMaterialIcon
EquipMaterialDataManager.GetMaterialQuality = GetMaterialQuality
EquipMaterialDataManager.GetMaterialCategoryName = GetMaterialCategoryName
EquipMaterialDataManager.GetCountById = GetCountById
EquipMaterialDataManager.GetMaterialCategory = GetMaterialCategory
return EquipMaterialDataManager
