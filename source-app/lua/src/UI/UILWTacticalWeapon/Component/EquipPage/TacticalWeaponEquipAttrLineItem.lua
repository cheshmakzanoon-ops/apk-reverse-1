local TacticalWeaponEquipAttrLineItem = BaseClass("TacticalWeaponEquipAttrLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_text_path = "NameText"
local value_text_path = "ValueText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, name_text_path)
  self.valueText = self:AddComponent(UIText, value_text_path)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, name, valueStr)
  if not name or not valueStr then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.nameText:SetLocalText(name)
  self.valueText:SetText(valueStr)
end

TacticalWeaponEquipAttrLineItem.OnCreate = OnCreate
TacticalWeaponEquipAttrLineItem.OnDestroy = OnDestroy
TacticalWeaponEquipAttrLineItem.ComponentDefine = ComponentDefine
TacticalWeaponEquipAttrLineItem.ComponentDestroy = ComponentDestroy
TacticalWeaponEquipAttrLineItem.DataDefine = DataDefine
TacticalWeaponEquipAttrLineItem.DataDestroy = DataDestroy
TacticalWeaponEquipAttrLineItem.OnEnable = OnEnable
TacticalWeaponEquipAttrLineItem.OnDisable = OnDisable
TacticalWeaponEquipAttrLineItem.SetData = SetData
return TacticalWeaponEquipAttrLineItem
