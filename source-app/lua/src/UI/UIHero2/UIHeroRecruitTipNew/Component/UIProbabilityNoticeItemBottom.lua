local UIProbabilityNoticeItemBottom = BaseClass("UIProbabilityNoticeItemBottom", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function UpdateItem(self)
end

UIProbabilityNoticeItemBottom.OnCreate = OnCreate
UIProbabilityNoticeItemBottom.OnDestroy = OnDestroy
UIProbabilityNoticeItemBottom.ComponentDefine = ComponentDefine
UIProbabilityNoticeItemBottom.ComponentDestroy = ComponentDestroy
UIProbabilityNoticeItemBottom.DataDefine = DataDefine
UIProbabilityNoticeItemBottom.DataDestroy = DataDestroy
UIProbabilityNoticeItemBottom.UpdateItem = UpdateItem
return UIProbabilityNoticeItemBottom
