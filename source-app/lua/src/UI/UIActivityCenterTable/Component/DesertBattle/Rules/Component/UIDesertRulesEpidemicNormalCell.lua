local UIDesertRulesEpidemicNormalCell = BaseClass("UIDesertRulesEpidemicNormalCell", UIBaseContainer)
local base = UIBaseContainer
local name_path = "bg/name"
local desc_path = "desc"

function UIDesertRulesEpidemicNormalCell:OnCreate()
  base.OnCreate(self)
  self.tmpName = self:AddComponent(UIText, name_path)
  self.tmpDesc = self:AddComponent(UIText, desc_path)
end

function UIDesertRulesEpidemicNormalCell:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesEpidemicNormalCell:ReInit(template, battleType)
  self.tmpName:SetLocalText(template.title)
  self.tmpDesc:SetLocalText(template.desc1)
end

return UIDesertRulesEpidemicNormalCell
