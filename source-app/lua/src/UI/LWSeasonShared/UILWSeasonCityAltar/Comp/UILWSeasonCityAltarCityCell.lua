local base = UIBaseContainer
local UILWSeasonCityAltarCityCell = BaseClass("UILWSeasonCityAltarCityCell", UIBaseContainer)

function UILWSeasonCityAltarCityCell:ComponentDefine()
  local p_img_icon_path = "p_img_icon"
  local p_text_level_path = "p_text_level"
  local p_text_location_path = "p_text_location"
  local p_text_name_path = "name/p_text_name"
  self.p_img_icon = self:AddComponent(UIImage, p_img_icon_path)
  self.p_text_level = self:AddComponent(UITextMeshProUGUIEx, p_text_level_path)
  self.p_text_location = self:AddComponent(UITextMeshProUGUIEx, p_text_location_path)
  self.p_text_location:OnPointerClick(BindCallback(self, self.OnLocationClick))
  self.p_text_name = self:AddComponent(UITextMeshProUGUIEx, p_text_name_path)
end

function UILWSeasonCityAltarCityCell:ComponentDestroy()
  self.p_img_icon = nil
  self.p_text_level = nil
  self.p_text_location = nil
  self.p_text_name = nil
end

function UILWSeasonCityAltarCityCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonCityAltarCityCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarCityCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonCityAltarCityCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonCityAltarCityCell:InitUi()
  self.p_img_icon:LoadSpriteAsync(self.Data:GetIconPath())
  self.p_text_name:SetText(self.Data:GetFullName())
  local pos = self.Data.pos
  if pos ~= nil then
    self.p_text_location:SetTextFormat("[%s, %s]", pos.x, pos.y)
  end
end

function UILWSeasonCityAltarCityCell:OnLocationClick()
  if self.Data ~= nil then
    self.Data:JumpTo()
  end
end

return UILWSeasonCityAltarCityCell
