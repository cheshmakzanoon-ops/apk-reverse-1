local base = UIBaseContainer
local LWUIActivityRewardChangePreview_AccuRechargeNewItem = BaseClass("LWUIActivityRewardChangePreview_AccuRechargeNewItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:ComponentDefine()
  self.imgScore = self:AddComponent(UIImage, "Score")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "Score/ScoreText")
  self.compUICommonResItem01 = self:AddComponent(UICommonResItem, "UICommonResItem01")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
  self.animatorLWUIActivityRewardChangePreviewAccuRechargeNewItem = self:AddComponent(UIAnimator, "")
  self.compItemFx = self:AddComponent(UIBaseComponent, "item_fx")
  self.compItemFx:SetActive(false)
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:ComponentDestroy()
  self.imgScore = nil
  self.textScore = nil
  self.compUICommonResItem01 = nil
  self.textNum = nil
  self.animatorLWUIActivityRewardChangePreviewAccuRechargeNewItem = nil
  self.compItemFx = nil
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:DataDestroy()
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:ReInit(score, scoreIcon, reward, useImgNativeSize)
  self.textScore:SetText(tostring(score))
  self.textNum:SetText(tostring(reward.count))
  reward.count = nil
  self.compUICommonResItem01:ReInit(reward)
  self.imgScore:LoadSprite(scoreIcon)
  if useImgNativeSize then
    self.imgScore:SetNativeSize()
  else
    self.imgScore:SetSizeDelta(Vector2(70, 70))
  end
end

function LWUIActivityRewardChangePreview_AccuRechargeNewItem:PlayIn()
  self.animatorLWUIActivityRewardChangePreviewAccuRechargeNewItem:Play("RewardChangePreview_AccuRecharge_NewItemIn")
end

return LWUIActivityRewardChangePreview_AccuRechargeNewItem
