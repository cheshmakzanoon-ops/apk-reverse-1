local base = UIBaseContainer
local ActivityDecorationGachaRulesTextItemComponent = BaseClass("ActivityDecorationGachaRulesTextItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActivityDecorationGachaRulesTextItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityDecorationGachaRulesTextItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityDecorationGachaRulesTextItemComponent:ComponentDefine()
  self.compRoot = self:AddComponent(UIBaseContainer, "")
  self.textBriefItem = self:AddComponent(UIText, "BriefItemText")
end

function ActivityDecorationGachaRulesTextItemComponent:ComponentDestroy()
  self.textBriefItem = nil
end

function ActivityDecorationGachaRulesTextItemComponent:DataDefine()
end

function ActivityDecorationGachaRulesTextItemComponent:DataDestroy()
end

function ActivityDecorationGachaRulesTextItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityDecorationGachaRulesTextItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityDecorationGachaRulesTextItemComponent:ReInit(str)
  self.textBriefItem:SetText(tostring(str))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compRoot.transform)
end

return ActivityDecorationGachaRulesTextItemComponent
