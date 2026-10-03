local p_img_benefit_dot_path = "p_img_benefit_dot"
local img_path = "p_img_benefit_dot/img"
local p_text_benefit_desc_path = "p_text_benefit_desc"
local p_content_benefit_value_path = "p_content_benefit_value"
local p_text_benefit_value_from_path = "p_content_benefit_value/p_text_benefit_value_from"
local arrow_path = "p_content_benefit_value/arrow"
local p_text_benefit_value_to_path = "p_content_benefit_value/p_text_benefit_value_to"
local base = UIBaseContainer
local UILWSeasonMilitaryBenefitCell = BaseClass("UILWSeasonMilitaryBenefitCell", UIBaseContainer)

function UILWSeasonMilitaryBenefitCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self.p_img_benefit_dot = self:AddComponent(UIBaseContainer, p_img_benefit_dot_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.p_text_benefit_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_benefit_desc_path)
  self.p_content_benefit_value = self:AddComponent(UIBaseContainer, p_content_benefit_value_path)
  self.p_text_benefit_value_from = self:AddComponent(UITextMeshProUGUIEx, p_text_benefit_value_from_path)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
  self.p_text_benefit_value_to = self:AddComponent(UITextMeshProUGUIEx, p_text_benefit_value_to_path)
end

function UILWSeasonMilitaryBenefitCell:ComponentDestroy()
  self.bg = nil
  self.p_img_benefit_dot = nil
  self.img = nil
  self.p_text_benefit_desc = nil
  self.p_content_benefit_value = nil
  self.p_text_benefit_value_from = nil
  self.arrow = nil
  self.p_text_benefit_value_to = nil
end

function UILWSeasonMilitaryBenefitCell:DataDefine()
end

function UILWSeasonMilitaryBenefitCell:DataDestroy()
end

function UILWSeasonMilitaryBenefitCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryBenefitCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryBenefitCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryBenefitCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonMilitaryBenefitCell:InitUi()
  self.p_text_benefit_desc:SetText(self.Data.Desc)
  self.p_text_benefit_desc:SetColorHex(self:GetDescColor())
  self.img:SetColorHex(self:GetDotColor())
  self.p_text_benefit_value_from:SetText(self.Data.FromStr)
  self.p_text_benefit_value_to:SetText(self.Data.ToStr)
  self.arrow:SetActive(not string.IsNullOrEmpty(self.Data.ToStr))
  if not self.Data.IsLevelUp then
    self.bg:SetColorHex(self:GetBgColor())
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_content_benefit_value.transform)
end

function UILWSeasonMilitaryBenefitCell:GetBgColor()
  if checknumber(self.Data.Index) % 2 == 1 then
    return "#E1EDC3"
  else
    return "#EDF3D6"
  end
end

function UILWSeasonMilitaryBenefitCell:GetDescColor()
  if self.Data.IsLevelUp then
    return self.Data.IsSpecial and "#FEB542" or "#FFFFFF"
  else
    return self.Data.IsSpecial and "#B36424" or "#736863"
  end
end

function UILWSeasonMilitaryBenefitCell:GetDotColor()
  if self.Data.IsLevelUp then
    return self.Data.IsSpecial and "#FDC839" or "#56667C"
  else
    return self.Data.IsSpecial and "#D9823C" or "#C5D8A6"
  end
end

return UILWSeasonMilitaryBenefitCell
