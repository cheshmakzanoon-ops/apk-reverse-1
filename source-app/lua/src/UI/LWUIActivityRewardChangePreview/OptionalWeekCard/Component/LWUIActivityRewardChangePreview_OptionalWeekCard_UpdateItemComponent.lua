local base = UIBaseContainer
local LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:ComponentDefine()
  self.compUICommonResItem01 = self:AddComponent(UICommonResItem, "UICommonResItem01")
  self.compUICommonResItem02 = self:AddComponent(UICommonResItem, "UICommonResItem02")
  self.animator = self:AddComponent(UIAnimator, "")
  self.compItemFx = self:AddComponent(UIBaseComponent, "item_fx")
  self.compItemFx:SetActive(false)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:ComponentDestroy()
  self.compUICommonResItem01 = nil
  self.compUICommonResItem02 = nil
  self.animator = nil
  self.compItemFx = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:DataDestroy()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:ReInit(preReward, newReward)
  self.compUICommonResItem01:ReInit(preReward)
  self.compUICommonResItem02:ReInit(newReward)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent:PlayIn()
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.animator:Play("RewardChangePreview_OptionalWeekCard_UpdateItemInAfan")
  else
    self.animator:Play("RewardChangePreview_OptionalWeekCard_UpdateItemIn")
  end
end

return LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent
