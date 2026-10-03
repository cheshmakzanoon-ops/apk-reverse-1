local base = UIBaseContainer
local LWUIActivityRewardChangePreview_AccuRecharge_Tips = BaseClass("LWUIActivityRewardChangePreview_AccuRecharge_Tips", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBaseComponent = require("Framework.UI.Base.UIBaseComponent")

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:ComponentDefine()
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "TipsText")
  self.anim = self.transform:GetComponent(typeof(CS.UnityEngine.Animation))
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:ComponentDestroy()
  self.textTips = nil
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:DataDefine()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:DataDestroy()
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:ReInit(tips)
  self.textTips:SetText(tips)
end

function LWUIActivityRewardChangePreview_AccuRecharge_Tips:PlayIn()
  if IsNotNull(self.anim) then
    self.anim:Play()
  end
end

return LWUIActivityRewardChangePreview_AccuRecharge_Tips
