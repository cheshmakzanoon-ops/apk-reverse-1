local base = UIBaseContainer
local LWUIActivityRewardChangePreview_OptionalWeekCard_Tips = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCard_Tips", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:ComponentDefine()
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "TipsText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:ComponentDestroy()
  self.textTips = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:DataDestroy()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:ReInit(text)
  self.textTips:SetText(text)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_Tips:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
    return
  end
end

return LWUIActivityRewardChangePreview_OptionalWeekCard_Tips
