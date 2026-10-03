local base = UIBaseContainer
local LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:ComponentDefine()
  self.compUICommonResItem01 = self:AddComponent(UICommonResItem, "UICommonResItem01")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:ComponentDestroy()
  self.compUICommonResItem01 = nil
  self.textNum = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:DataDefine()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:DataDestroy()
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:ReInit(reward)
  self.compUICommonResItem01:ReInit(reward)
  self.textNum:SetText(tostring(reward.count))
end

function LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
  end
end

return LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent
