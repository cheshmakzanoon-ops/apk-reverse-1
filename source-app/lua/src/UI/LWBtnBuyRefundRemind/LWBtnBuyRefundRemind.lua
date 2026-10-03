local base = UIBaseContainer
local LWBtnBuyRefundRemind = BaseClass("LWBtnBuyRefundRemind", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")

function LWBtnBuyRefundRemind:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWBtnBuyRefundRemind:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWBtnBuyRefundRemind:ComponentDefine()
  self.textPrice = self:TryAddComponent(UITextMeshProUGUIEx, "BuyBtn/TextNode/PriceText")
  self.btnInfo = self:TryAddComponent(UIButton, "InfoBtn")
  if self.btnInfo then
    self.btnInfo:SetOnClick(function()
      self:OnBtnInfoClick()
    end)
  end
  self.textRefund = self:TryAddComponent(UITextMeshProUGUIEx, "InfoBtn/RefundText")
  self.textDiscount = self:TryAddComponent(UITextMeshProUGUIEx, "BuyBtn/TextNode/DiscountText")
  self.btnBuy = self:TryAddComponent(UIButton, "BuyBtn")
  if self.btnBuy then
    self.btnBuy:SetOnClick(function()
      self:OnBtnBuyClick()
    end)
  end
  self.giftPackagePoint = self:TryAddComponent(UIGiftPackagePoint, "UIGiftPackagePoint")
  self.infoImage = self:TryAddComponent(UIBaseContainer, "InfoBtn/InfoImage")
  if self.textRefund then
    self.textRefund:SetLocalText("refund_nonrefundable_button")
  end
  if self.textDiscount then
    self.textDiscount:SetActive(false)
  end
  if self.giftPackagePoint then
    self.giftPackagePoint:SetActive(false)
  end
  self.textPrice:SetRichText(true)
  self:HideInfoBtnIfKrRefund()
end

function LWBtnBuyRefundRemind:ComponentDestroy()
  self.textPrice = nil
  self.btnInfo = nil
  self.textRefund = nil
  self.textDiscount = nil
  self.btnBuy = nil
  self.giftPackagePoint = nil
  self.infoImage = nil
end

function LWBtnBuyRefundRemind:DataDefine()
  self.packageData = nil
  self.buyBtnClickAction = nil
  self.buyBtnClickCallBack = nil
end

function LWBtnBuyRefundRemind:DataDestroy()
  self.packageData = nil
  self.buyBtnClickAction = nil
  self.buyBtnClickCallBack = nil
end

function LWBtnBuyRefundRemind:OnAddListener()
  base.OnAddListener(self)
end

function LWBtnBuyRefundRemind:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWBtnBuyRefundRemind:InitByData(packageData)
  if not packageData then
    self.textPrice:SetText("")
    Logger.LogError("packageData is nil")
    return
  end
  self.packageData = packageData
  local cost = self.packageData:getPriceText()
  if self.textPrice then
    self.textPrice:SetText(cost)
  end
  local show = LuaEntry.DataConfig:CheckSwitch("refund_client3") and not self.packageData:getCanRefund()
  if self.btnInfo and self.textRefund then
    self.btnInfo:SetActive(show)
    self.textRefund:SetActive(show)
    if show then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btnInfo.rectTransform)
    end
  end
  self:HideInfoBtnIfKrRefund()
end

function LWBtnBuyRefundRemind:OnBtnInfoClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  local days = DataCenter.LWRefundManager:GetRefundLimitDays()
  param.desc = Localization:GetString("refund_nonrefundable_description", days)
  param.isLocal = true
  param.alignObject = self.infoImage
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function LWBtnBuyRefundRemind:OnBtnBuyClick()
  if self.buyBtnClickAction then
    self.buyBtnClickAction()
  else
    if not self.packageData then
      return
    end
    DataCenter.PayManager:CallPayment(self.packageData)
    if self.buyBtnClickCallBack then
      self.buyBtnClickCallBack()
    end
  end
end

function LWBtnBuyRefundRemind:HideInfoBtnIfKrRefund()
  local isKoreaRegion = CS.GameEntry.Sdk:IsKoreaRegion()
  if isKoreaRegion and self.btnInfo then
    self.btnInfo:SetActive(false)
  end
end

function LWBtnBuyRefundRemind:Init(packageData)
  self:InitByData(packageData)
end

function LWBtnBuyRefundRemind:SetBuyClickAction(action)
  self.buyBtnClickAction = action
end

function LWBtnBuyRefundRemind:SetBuyClickCallBack(action)
  self.buyBtnClickCallBack = action
end

function LWBtnBuyRefundRemind:SetDiscountText(discount)
  self.textDiscount:SetText(discount)
  self.textDiscount:SetActive(true)
end

function LWBtnBuyRefundRemind:RefreshPoint()
  if not self.packageData then
    Logger.Log("packageData is nil")
    return
  end
  self.giftPackagePoint:RefreshPoint(self.packageData)
end

function LWBtnBuyRefundRemind:SetSafeClickMode(safeMode)
  if self.btnBuy then
    self.btnBuy:SetSafeClickMode(safeMode)
  end
end

function LWBtnBuyRefundRemind:SetPackagePointShow(show)
  if self.giftPackagePoint then
    self.giftPackagePoint:SetActive(show)
  end
end

function LWBtnBuyRefundRemind:SetPriceText(priceText)
  if self.textPrice then
    self.textPrice:SetActive(true)
    self.textPrice:SetText(priceText)
  end
end

function LWBtnBuyRefundRemind:ShowDiscountText(show)
  if self.textDiscount then
    self.textDiscount:SetActive(show)
  end
end

function LWBtnBuyRefundRemind:SetGray(bGray, canClick)
  if self.btnBuy then
    CS.UIGray.SetGray(self.btnBuy.transform, bGray, canClick)
  end
end

function LWBtnBuyRefundRemind:SetBuyButtonInteractable(value)
  if self.btnBuy then
    self.btnBuy:SetInteractable(value)
  end
end

return LWBtnBuyRefundRemind
