local LineItem = BaseClass("LineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, "EffectNameText")
  self.valueText = self:AddComponent(UIText, "EffectValueText")
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
end

local function DataDestroy(self)
end

local function SetData(self, name, value)
  self.nameText:SetLocalText(name)
  self.valueText:SetText(value)
end

LineItem.OnCreate = OnCreate
LineItem.OnDestroy = OnDestroy
LineItem.ComponentDefine = ComponentDefine
LineItem.ComponentDestroy = ComponentDestroy
LineItem.DataDefine = DataDefine
LineItem.DataDestroy = DataDestroy
LineItem.SetData = SetData
return LineItem
