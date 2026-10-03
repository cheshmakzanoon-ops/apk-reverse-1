local UILWCityShieldView = BaseClass("UILWCityShieldView", UIBaseView)
local base = UIBaseView
local CityShieldPage = require("UI.UILWCityShield.Component.CityShieldPage")

function UILWCityShieldView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWCityShieldView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCityShieldView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/CloseBtn")
  self.return_btn = self:AddComponent(UIButton, "ImgBg/UICommonPopUpTitle/panel")
  self.title_txt = self:AddComponent(UIText, "ImgBg/UICommonPopUpTitle/Common_img_title/titleText")
  self.title_txt:SetLocalText(GameDialogDefine.CITY_SHIELD_PANEL)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.page = self:AddComponent(CityShieldPage, "ImgBg/ScrollView")
end

function UILWCityShieldView:ComponentDestroy()
end

return UILWCityShieldView
