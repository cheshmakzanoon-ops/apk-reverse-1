local UIBuyGiftBtn = BaseClass("UIBuyGiftBtn", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray
local btn_path = "Btn"
local origin_price_layout_path = "Btn/PriceLayout/OriginPriceLayout"
local origin_price_text_path = "Btn/PriceLayout/OriginPriceLayout/OriginPriceText"
local price_text_path = "Btn/PriceLayout/PriceText"
local ui_gift_package_point_path = "Btn/UIGiftPackagePoint"

function UIBuyGiftBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if not self.giftPackageData then
      return
    end
    if self.giftPackageData:canGet() then
      DataCenter.PayManager:CallPayment(self.giftPackageData, nil)
    end
  end)
  self.originPriceLayout = self:AddComponent(UIBaseContainer, origin_price_layout_path)
  self.originPriceText = self:AddComponent(UIText, origin_price_text_path)
  self.priceText = self:AddComponent(UIText, price_text_path)
  self.uiGiftPackagePoint = self:AddComponent(UIGiftPackagePoint, ui_gift_package_point_path)
end

function UIBuyGiftBtn:ComponentDestroy()
  self.btn = nil
  self.originPriceLayout = nil
  self.originPriceText = nil
  self.priceText = nil
  self.uiGiftPackagePoint = nil
end

function UIBuyGiftBtn:DataDefine()
  self.giftPackageData = nil
end

function UIBuyGiftBtn:DataDestroy()
  self.giftPackageData = nil
end

function UIBuyGiftBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBuyGiftBtn:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIBuyGiftBtn:OnEnable()
  base.OnEnable(self)
end

function UIBuyGiftBtn:OnDisable()
  base.OnDisable(self)
end

function UIBuyGiftBtn:RefreshUI(showOriginPrice)
  self:SetActive(true)
  if showOriginPrice then
    self.originPriceLayout:SetActive(true)
    self.originPriceText:SetText(self.giftPackageData:getOriginalPriceText())
  else
    self.originPriceLayout:SetActive(false)
  end
  self.priceText:SetText(self.giftPackageData:getPriceText())
  self.uiGiftPackagePoint:SetData(self.giftPackageData)
  if self.giftPackageData:canGet() then
    UIGray.SetGray(self.btn.transform, false, true)
  else
    UIGray.SetGray(self.btn.transform, true, true)
  end
end

function UIBuyGiftBtn:SetData(giftPackageData, showOriginPrice)
  self.giftPackageData = giftPackageData
  if self.giftPackageData == nil then
    self:SetActive(false)
    return
  end
  self:RefreshUI(showOriginPrice)
end

function UIBuyGiftBtn:SetPrice(price, originalPrice)
  self.priceText:SetText(price)
  if originalPrice then
    self.originPriceText:SetActive(true)
    self.originPriceText:SetText(originalPrice)
  else
    self.originPriceText:SetActive(false)
  end
  self.uiGiftPackagePoint:SetActive(false)
end

return UIBuyGiftBtn
