local base = UIBaseContainer
local LWUIActivityRewardChangePreview_AccuRechargeUpdateItem = BaseClass("LWUIActivityRewardChangePreview_AccuRechargeUpdateItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:ComponentDefine()
  self.imgScore = self:AddComponent(UIImage, "Score")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "Score/ScoreText")
  self.compUICommonResItem01 = self:AddComponent(UICommonResItem, "UICommonResItem01")
  self.compUICommonResItem02 = self:AddComponent(UICommonResItem, "UICommonResItem02")
  self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem = self:AddComponent(UIAnimator, "")
  self.compItemFx = self:AddComponent(UIBaseComponent, "item_fx")
  self.compItemFx:SetActive(false)
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:ComponentDestroy()
  self.imgScore = nil
  self.textScore = nil
  self.compUICommonResItem01 = nil
  self.compUICommonResItem02 = nil
  self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem = nil
  self.compItemFx = nil
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:DataDestroy()
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:ReInit(score, scoreIcon, preReward, newReward, dontSetScore)
  if not dontSetScore then
    self.textScore:SetText(tostring(score))
    self.imgScore:LoadSprite(scoreIcon)
    self.imgScore:SetNativeSize()
  end
  self.compUICommonResItem01:ReInit(preReward)
  self.compUICommonResItem02:ReInit(newReward)
  self.isShowNumChangeAnim = false
  if preReward.count ~= newReward.count then
    self.isShowNumChangeAnim = true
  end
end

function LWUIActivityRewardChangePreview_AccuRechargeUpdateItem:PlayIn(isPlay)
  if isPlay then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      if self.isShowNumChangeAnim then
        self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("LWUIActivityRewardChangePreview_AccuRecharge_UpdateItemAfan_NumberChange")
      else
        self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("LWUIActivityRewardChangePreview_AccuRecharge_UpdateItemAfan")
      end
    elseif self.isShowNumChangeAnim then
      self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("RewardChangePreview_AccuRecharge_UpdateItemIn_NumberChange")
    else
      self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("RewardChangePreview_AccuRecharge_UpdateItemIn")
    end
  elseif CommonUtil.IsArabicAutoMirrorOpen() then
    self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("LWUIActivityRewardChangePreview_AccuRecharge_UpdateItemAfan", 0, 1)
  else
    self.animatorLWUIActivityRewardChangePreviewAccuRechargeUpdateItem:Play("RewardChangePreview_AccuRecharge_UpdateItemIn", 0, 1)
  end
end

return LWUIActivityRewardChangePreview_AccuRechargeUpdateItem
