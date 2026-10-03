local base = UIBaseContainer
local AllyDuelScoreGachaRulesTextItemComponent = BaseClass("AllyDuelScoreGachaRulesTextItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AllyDuelScoreGachaRulesTextItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelScoreGachaRulesTextItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelScoreGachaRulesTextItemComponent:ComponentDefine()
  self.compRoot = self:AddComponent(UIBaseContainer, "")
  self.textBriefItem = self:AddComponent(UIText, "BriefItemText")
end

function AllyDuelScoreGachaRulesTextItemComponent:ComponentDestroy()
  self.textBriefItem = nil
end

function AllyDuelScoreGachaRulesTextItemComponent:DataDefine()
end

function AllyDuelScoreGachaRulesTextItemComponent:DataDestroy()
end

function AllyDuelScoreGachaRulesTextItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelScoreGachaRulesTextItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelScoreGachaRulesTextItemComponent:ReInit(str)
  self.textBriefItem:SetText(tostring(str))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compRoot.transform)
end

return AllyDuelScoreGachaRulesTextItemComponent
