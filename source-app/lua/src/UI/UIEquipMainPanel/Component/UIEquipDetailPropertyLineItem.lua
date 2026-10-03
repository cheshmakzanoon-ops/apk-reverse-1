local UIEquipDetailPropertyLineItem = BaseClass("UIEquipDetailPropertyLineItem", UIBaseContainer)
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
  self.propertyData = nil
  self.equipLevel = nil
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
  self.lockContent = self:AddComponent(UIBaseContainer, "LockContent")
  self.unlockLevelText = self:AddComponent(UIText, "LockContent/UnlockLvBg/UnlockLevelText")
  self.lockPropertyText = self:AddComponent(UIText, "LockContent/PropertyText")
  self.unlockContent = self:AddComponent(UIBaseContainer, "UnlockContent")
  self.nameText = self:AddComponent(UIText, "UnlockContent/NameText")
  self.valueText = self:AddComponent(UIText, "UnlockContent/ValueText")
end

local function ComponentDestroy(self)
  self.lockContent = nil
  self.unlockLevelText = nil
  self.lockPropertyText = nil
  self.unlockContent = nil
  self.nameText = nil
  self.valueText = nil
end

local function RefreshShowData(self)
  local isUnlock = self.propertyData.unlockLevel <= self.equipLevel
  local propertyName = HeroUtils.GetHeroPropertyNameId(self.propertyData.id)
  local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(self.propertyData.id, self.propertyData.value)
  if isUnlock then
    self.lockContent:SetActive(false)
    self.unlockContent:SetActive(true)
    self.nameText:SetLocalText(propertyName)
    self.valueText:SetText(formattedPropertyValueStr)
  else
    self.lockContent:SetActive(true)
    self.unlockContent:SetActive(false)
    self.unlockLevelText:SetText("Lv." .. self.propertyData.unlockLevel)
    self.lockPropertyText:SetText(Localization:GetString(propertyName) .. "  " .. formattedPropertyValueStr)
  end
end

local function SetData(self, propertyData, equipLevel)
  if propertyData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.propertyData = propertyData
  self.equipLevel = equipLevel
  RefreshShowData(self)
end

local function SetEquipLevel(self, equipLevel)
  if self.propertyData == nil then
    return
  end
  self.equipLevel = equipLevel
  RefreshShowData(self)
end

UIEquipDetailPropertyLineItem.OnCreate = OnCreate
UIEquipDetailPropertyLineItem.OnDestroy = OnDestroy
UIEquipDetailPropertyLineItem.OnEnable = OnEnable
UIEquipDetailPropertyLineItem.OnDisable = OnDisable
UIEquipDetailPropertyLineItem.DataDefine = DataDefine
UIEquipDetailPropertyLineItem.DataDestroy = DataDestroy
UIEquipDetailPropertyLineItem.ComponentDefine = ComponentDefine
UIEquipDetailPropertyLineItem.ComponentDestroy = ComponentDestroy
UIEquipDetailPropertyLineItem.SetData = SetData
UIEquipDetailPropertyLineItem.SetEquipLevel = SetEquipLevel
return UIEquipDetailPropertyLineItem
