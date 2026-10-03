local UIEquipBasicPropertyLineItem = BaseClass("UIEquipBasicPropertyLineItem", UIBaseContainer)
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
  self.propertyData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self.equipPropEffect:SetActive(false)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "NameText")
  self.valueText = self:AddComponent(UIText, "ValueText")
  self.equipPropEffect = self:AddComponent(UIBaseContainer, "Eff_ui_hero_xiangqing_qianghua_shuaguang")
  self.equipPropEffect:SetActive(false)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
  self.equipPropEffect = nil
end

local function RefreshShowData(self)
  local propertyName = HeroUtils.GetHeroPropertyNameId(self.propertyData.id)
  local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(self.propertyData.id, self.propertyData.value)
  self.nameText:SetLocalText(propertyName)
  self.valueText:SetText(formattedPropertyValueStr)
end

local function SetData(self, propertyData)
  if propertyData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.propertyData = propertyData
  RefreshShowData(self)
end

UIEquipBasicPropertyLineItem.OnCreate = OnCreate
UIEquipBasicPropertyLineItem.OnDestroy = OnDestroy
UIEquipBasicPropertyLineItem.OnEnable = OnEnable
UIEquipBasicPropertyLineItem.OnDisable = OnDisable
UIEquipBasicPropertyLineItem.DataDefine = DataDefine
UIEquipBasicPropertyLineItem.DataDestroy = DataDestroy
UIEquipBasicPropertyLineItem.ComponentDefine = ComponentDefine
UIEquipBasicPropertyLineItem.ComponentDestroy = ComponentDestroy
UIEquipBasicPropertyLineItem.SetData = SetData
return UIEquipBasicPropertyLineItem
