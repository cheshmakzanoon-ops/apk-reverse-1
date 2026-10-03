local BuildUpgradeExtraTipItem = BaseClass("BuildUpgradeExtraTipItem", UIBaseContainer)
local base = UIBaseContainer

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
  self.desc = self:AddComponent(UIText, "desc")
  self.value = self:AddComponent(UIText, "value")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, desc, value)
  self.desc:SetText(desc)
  self.value:SetText(value)
end

BuildUpgradeExtraTipItem.OnCreate = OnCreate
BuildUpgradeExtraTipItem.OnDestroy = OnDestroy
BuildUpgradeExtraTipItem.ComponentDefine = ComponentDefine
BuildUpgradeExtraTipItem.ComponentDestroy = ComponentDestroy
BuildUpgradeExtraTipItem.DataDefine = DataDefine
BuildUpgradeExtraTipItem.DataDestroy = DataDestroy
BuildUpgradeExtraTipItem.SetData = SetData
return BuildUpgradeExtraTipItem
