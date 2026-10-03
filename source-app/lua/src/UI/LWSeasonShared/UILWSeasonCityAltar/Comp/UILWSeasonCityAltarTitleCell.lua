local base = UIBaseContainer
local UILWSeasonCityAltarTitleCell = BaseClass("UILWSeasonCityAltarTitleCell", UIBaseContainer)

function UILWSeasonCityAltarTitleCell:ComponentDefine()
  local p_text_altar_group_title_path = "p_text_altar_group_title"
  self.p_text_altar_group_title = self:AddComponent(UITextMeshProUGUIEx, p_text_altar_group_title_path)
end

function UILWSeasonCityAltarTitleCell:ComponentDestroy()
  self.p_text_altar_group_title = nil
end

function UILWSeasonCityAltarTitleCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonCityAltarTitleCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarTitleCell:ReInit(text)
  self.p_text_altar_group_title:SetText(text)
end

return UILWSeasonCityAltarTitleCell
