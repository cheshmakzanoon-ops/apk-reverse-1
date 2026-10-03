local UICommonShopTabItem = BaseClass("UICommonShopTabItem", UIToggle)
local base = UIToggle
local COLOR_SELECTED = UIUtil.HexToColor("#FFFFFF")
local COLOR_UNSELECTED = UIUtil.HexToColor("#CCC8C6")

function UICommonShopTabItem:OnCreate()
  base.OnCreate(self)
  self.img_warn = self:AddComponent(UIImage, "ImgWarn")
  self.txt_num = self:AddComponent(UIText, "ImgWarn/TxtNum")
  self.txt_title = self:AddComponent(UIText, "TxtTitle")
end

function UICommonShopTabItem:OnDestroy()
  self.img_warn = nil
  self.txt_num = nil
  self.txt_title = nil
  base.OnDestroy(self)
end

function UICommonShopTabItem:ReInit(data)
  self.shopType = data.ShopType
  self.img_warn:SetActive(false)
  self.txt_title:SetLocalText(data.Title)
end

function UICommonShopTabItem:RefreshToggleRed()
  local redCount = DataCenter.CommonShopManager:GetRedCount(self.shopType)
  if 0 < redCount then
    self.img_warn:SetActive(true)
    if redCount == 1 then
      self.txt_num:SetText("")
    else
      self.txt_num:SetText(tostring(redCount))
    end
  else
    self.img_warn:SetActive(false)
  end
end

function UICommonShopTabItem:ChangeTextTitleColor(value)
  self.txt_title:SetColor(value and COLOR_SELECTED or COLOR_UNSELECTED)
end

return UICommonShopTabItem
