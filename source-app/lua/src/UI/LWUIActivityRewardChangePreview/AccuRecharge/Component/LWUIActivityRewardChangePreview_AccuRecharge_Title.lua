local base = UIBaseContainer
local LWUIActivityRewardChangePreview_AccuRecharge_Title = BaseClass("LWUIActivityRewardChangePreview_AccuRecharge_Title", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_AccuRecharge_Title:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  self.animator = self:AddComponent(UIAnimator, "")
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:ComponentDestroy()
  self.textTitle = nil
  self.anim = nil
  self.animator = nil
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:DataDestroy()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:ReInit(title)
  self.textTitle:SetText(title)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Title:PlayIn(isPlay)
  if isPlay then
    if IsNotNull(self.anim) then
      self.anim:Play()
      return
    end
    if IsNotNull(self.animator) then
      self.animator:Play("RewardChangePreview_AccuRechargeUpdateIn")
    end
  elseif IsNotNull(self.animator) then
    self.animator:Play("RewardChangePreview_AccuRechargeUpdateIn", 0, 1)
  end
end

return LWUIActivityRewardChangePreview_AccuRecharge_Title
