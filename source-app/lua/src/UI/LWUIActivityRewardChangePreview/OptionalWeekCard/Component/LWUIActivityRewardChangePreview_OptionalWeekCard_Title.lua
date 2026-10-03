local base = UIBaseContainer
local LWUIActivityRewardChangePreview_OptionalWeekCard_Title = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCard_Title", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  self.animator = self.transform:GetComponent(typeof(CS.UnityEngine.Animator))
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:ComponentDestroy()
  self.textTitle = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:DataDestroy()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:ReInit(title)
  self.textTitle:SetText(title)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Title:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
    return
  end
  if IsNotNull(self.animator) then
    self.animator:Play("RewardChangePreview_AccuRechargeUpdateIn")
    return
  end
end

return LWUIActivityRewardChangePreview_OptionalWeekCard_Title
