local base = UIBaseContainer
local UIActEpidemicSkillDescDetailItem = BaseClass("UIActEpidemicSkillDescDetailItem", base)

function UIActEpidemicSkillDescDetailItem:OnCreate()
  base.OnCreate(self)
  self.descText = self:AddComponent(UITextMeshProUGUIEx, "Desc")
end

function UIActEpidemicSkillDescDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicSkillDescDetailItem:Refresh(desc)
  self.descText:SetText(desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.descText.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return UIActEpidemicSkillDescDetailItem
