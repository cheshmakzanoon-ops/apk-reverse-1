local UIProbabilityNoticeIteMiddle = BaseClass("UIProbabilityNoticeIteMiddle", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, "Content")
end

local function ComponentDestroy(self)
  self.content = nil
end

local function UpdateItem(self, data)
end

UIProbabilityNoticeIteMiddle.OnCreate = OnCreate
UIProbabilityNoticeIteMiddle.OnDestroy = OnDestroy
UIProbabilityNoticeIteMiddle.ComponentDefine = ComponentDefine
UIProbabilityNoticeIteMiddle.ComponentDestroy = ComponentDestroy
UIProbabilityNoticeIteMiddle.UpdateItem = UpdateItem
return UIProbabilityNoticeIteMiddle
