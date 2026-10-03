local UILWSeasonVirusDetailItem = BaseClass("UILWSeasonVirusDetailItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonVirusDetailItem:OnCreate()
  base.OnCreate(self)
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, "DescText")
end

function UILWSeasonVirusDetailItem:OnDestroy()
  base.OnDestroy(self)
  self.layoutElement = nil
  self.desc_text = nil
end

function UILWSeasonVirusDetailItem:ReInit()
  local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, theEffectId)
  if stateMeta and stateMeta.info then
    self.desc_text:SetLocalText(stateMeta.info)
  else
    self.desc_text:SetLocalText("season_buff_virus_info001")
  end
end

function UILWSeasonVirusDetailItem:Update100MS()
  self.layoutElement:SetPreferredHeight(20 + self.desc_text:GetHeight())
end

return UILWSeasonVirusDetailItem
