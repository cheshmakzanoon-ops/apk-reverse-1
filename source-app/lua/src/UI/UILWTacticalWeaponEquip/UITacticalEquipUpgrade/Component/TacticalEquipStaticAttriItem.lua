local TacticalEquipStaticAttriItem = BaseClass("TacticalEquipStaticAttriItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.textValue = self:AddComponent(UITextMeshProUGUIEx, "value")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textValue = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TacticalEquipStaticAttriItem:SetData(data)
  self.textTitle:SetLocalText(data.title)
  self.textValue:SetText(data.curValue)
end

TacticalEquipStaticAttriItem.OnCreate = OnCreate
TacticalEquipStaticAttriItem.OnDestroy = OnDestroy
TacticalEquipStaticAttriItem.OnEnable = OnEnable
TacticalEquipStaticAttriItem.OnDisable = OnDisable
TacticalEquipStaticAttriItem.ComponentDefine = ComponentDefine
TacticalEquipStaticAttriItem.ComponentDestroy = ComponentDestroy
TacticalEquipStaticAttriItem.DataDefine = DataDefine
TacticalEquipStaticAttriItem.DataDestroy = DataDestroy
return TacticalEquipStaticAttriItem
