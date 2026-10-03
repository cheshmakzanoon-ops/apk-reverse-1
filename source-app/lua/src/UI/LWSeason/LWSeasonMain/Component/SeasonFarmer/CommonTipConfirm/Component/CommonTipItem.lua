local base = UIBaseContainer
local CommonTipItem = BaseClass("CommonTipItem", base)
local DesText_path = ""
local line_path = "line"

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
  self.DesText = self:AddComponent(UIText, DesText_path)
  self.line = self:AddComponent(UIBaseContainer, line_path)
end

local function ComponentDestroy(self)
  self.DesText = nil
  self.line = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CommonTipItem:ReInit(data)
  self.DesText:SetText(data)
end

CommonTipItem.OnCreate = OnCreate
CommonTipItem.OnDestroy = OnDestroy
CommonTipItem.OnEnable = OnEnable
CommonTipItem.OnDisable = OnDisable
CommonTipItem.ComponentDefine = ComponentDefine
CommonTipItem.ComponentDestroy = ComponentDestroy
CommonTipItem.DataDefine = DataDefine
CommonTipItem.DataDestroy = DataDestroy
return CommonTipItem
