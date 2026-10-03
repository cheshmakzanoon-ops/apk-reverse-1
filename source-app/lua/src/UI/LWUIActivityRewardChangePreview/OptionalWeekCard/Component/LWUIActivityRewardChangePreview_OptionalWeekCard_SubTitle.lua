local base = UIBaseContainer
local LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:ComponentDefine()
  self.textSubTitle = self:AddComponent(UITextMeshProUGUIEx, "SubTitleText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:ComponentDestroy()
  self.textSubTitle = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:DataDestroy()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:ReInit(text)
  self.textSubTitle:SetText(text)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
    return
  end
end

return LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle
