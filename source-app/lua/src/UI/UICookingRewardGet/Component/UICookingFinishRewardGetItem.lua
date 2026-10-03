local UICookingFinishRewardGetItem = BaseClass("UICookingFinishRewardGetItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.extraText = self:AddComponent(UIText, "ExtraIcon/Text")
  self.extraText:SetLocalText("thanksactivity_UI028")
  self.extraIcon = self:AddComponent(UIBaseContainer, "ExtraIcon")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
end

local function ReInit(self, param, isExtra)
  self.extraIcon:SetActive(isExtra)
  self.uiCommonResItem:ReInit(param)
end

UICookingFinishRewardGetItem.OnCreate = OnCreate
UICookingFinishRewardGetItem.OnDestroy = OnDestroy
UICookingFinishRewardGetItem.ComponentDefine = ComponentDefine
UICookingFinishRewardGetItem.ReInit = ReInit
return UICookingFinishRewardGetItem
