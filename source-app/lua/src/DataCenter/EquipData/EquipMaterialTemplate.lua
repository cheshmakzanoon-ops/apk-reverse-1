local EquipMaterialTemplate = BaseClass("EquipMaterialTemplate")

local function __init(self)
  self.id = 0
  self.resourceItem_Id = 0
  self.quality = 0
  self.category = 0
  self.resourceItemTemplate = nil
  self.icon = ""
  self.name = ""
  self.desc = ""
end

local function __delete(self)
  self.id = nil
  self.resourceItem_Id = nil
  self.quality = nil
  self.category = nil
  self.resourceItemTemplate = nil
  self.icon = nil
  self.name = nil
  self.desc = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.resourceItem_Id = self.id
  self.quality = tonumber(row:getValue("quality")) or 0
  self.category = tonumber(row:getValue("category")) or 0
  if 0 < self.resourceItem_Id then
    self.resourceItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.resourceItem_Id)
    if self.resourceItemTemplate ~= nil then
      self.icon = self.resourceItemTemplate.pic
      self.name = self.resourceItemTemplate.name
      self.desc = self.resourceItemTemplate.desc
      self.quality = self.resourceItemTemplate.quality
    end
  end
end

EquipMaterialTemplate.__init = __init
EquipMaterialTemplate.__delete = __delete
EquipMaterialTemplate.InitData = InitData
return EquipMaterialTemplate
