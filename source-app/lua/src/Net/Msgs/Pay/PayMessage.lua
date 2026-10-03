local PayMessage = BaseClass("PayAmazonMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("orderId", param.orderId or "")
  self.sfsObj:PutUtfString("productId", param.productId)
  self.sfsObj:PutUtfString("purchaseTime", param.purchaseTime)
  self.sfsObj:PutUtfString("signData", param.signData)
  self.sfsObj:PutUtfString("signature", param.signature)
  self.sfsObj:PutUtfString("itemId", param.itemId)
  local _currency = DataCenter.PayManager:__GetLocalCurrencyCode() or ""
  local _localPrice = DataCenter.PayManager:GetLocalCurrency(param.productId) or ""
  self.sfsObj:PutUtfString("pay_countryOfAccountOfPlatform", "")
  if param.currencyCode then
    self.sfsObj:PutUtfString("pay_closingCurrency", param.currencyCode)
  else
    self.sfsObj:PutUtfString("pay_closingCurrency", _currency)
  end
  if param.currencyNumber then
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", param.currencyNumber)
  else
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", _localPrice)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.usePush and t.usePush == true then
    return
  end
  DataCenter.PayManager:PayMessageHandle(t)
end

PayMessage.OnCreate = OnCreate
PayMessage.HandleMessage = HandleMessage
return PayMessage
