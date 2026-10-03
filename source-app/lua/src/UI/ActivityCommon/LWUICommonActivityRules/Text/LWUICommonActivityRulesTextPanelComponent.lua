local base = UIBaseContainer
local LWUICommonActivityRulesTextPanelComponent = BaseClass("LWUICommonActivityRulesTextPanelComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICommonActivityRulesTextPanelComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonActivityRulesTextPanelComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonActivityRulesTextPanelComponent:ComponentDefine()
  self.compContent = self:AddComponent(UIBaseComponent, "ScrollView/Viewport/Content")
  self.textBrief = self:AddComponent(UITextMeshProUGUIEx, "ScrollView/Viewport/Content/BriefText")
end

function LWUICommonActivityRulesTextPanelComponent:ComponentDestroy()
  self.compContent = nil
  self.textBrief = nil
end

function LWUICommonActivityRulesTextPanelComponent:DataDefine()
end

function LWUICommonActivityRulesTextPanelComponent:DataDestroy()
end

function LWUICommonActivityRulesTextPanelComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonActivityRulesTextPanelComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICommonActivityRulesTextPanelComponent:RefreshByText(text)
  self.textBrief:SetText(text)
  self.compContent:SetAnchoredPositionXY(0, 0)
end

return LWUICommonActivityRulesTextPanelComponent
