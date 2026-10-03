local UIEquipPropertyLineItem = BaseClass("UIEquipPropertyLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.equipData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.valueText = self:AddComponent(UIText, "ValueText")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
end

local function SetData(self, propertyData)
  if propertyData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  local propertyName = HeroUtils.GetHeroPropertyNameId(propertyData.id)
  local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(propertyData.id, propertyData.value)
  self.nameText:SetLocalText(propertyName)
  self.valueText:SetText(formattedPropertyValueStr)
end

UIEquipPropertyLineItem.OnCreate = OnCreate
UIEquipPropertyLineItem.OnDestroy = OnDestroy
UIEquipPropertyLineItem.OnEnable = OnEnable
UIEquipPropertyLineItem.OnDisable = OnDisable
UIEquipPropertyLineItem.DataDefine = DataDefine
UIEquipPropertyLineItem.DataDestroy = DataDestroy
UIEquipPropertyLineItem.ComponentDefine = ComponentDefine
UIEquipPropertyLineItem.ComponentDestroy = ComponentDestroy
UIEquipPropertyLineItem.SetData = SetData
return UIEquipPropertyLineItem
