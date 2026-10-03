local UIGiftBoxOpenRewardGetItem = BaseClass("UIGiftBoxOpenRewardGetItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.doubleIcon = self:AddComponent(UIBaseContainer, "DoubleIcon")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
end

local function ReInit(self, param, isDouble)
  self.doubleIcon:SetActive(isDouble)
  if isDouble then
    param.count = param.count / 2
  end
  self.uiCommonResItem:ReInit(param)
end

UIGiftBoxOpenRewardGetItem.OnCreate = OnCreate
UIGiftBoxOpenRewardGetItem.OnDestroy = OnDestroy
UIGiftBoxOpenRewardGetItem.ComponentDefine = ComponentDefine
UIGiftBoxOpenRewardGetItem.ReInit = ReInit
return UIGiftBoxOpenRewardGetItem
