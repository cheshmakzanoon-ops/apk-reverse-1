local PayIOSMessage = BaseClass("PayIOSMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("orderId", param.orderId)
  self.sfsObj:PutUtfString("sSignedData", param.sSignedData)
  self.sfsObj:PutUtfString("productId", param.productId)
  self.sfsObj:PutUtfString("itemId", param.itemId)
  self.sfsObj:PutUtfString("pay_countryOfAccountOfPlatform", "")
  local priceNumber = tonumber(param.priceNumber)
  if priceNumber ~= nil and 0 < priceNumber then
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", param.priceNumber)
    Logger.LogInfo("payios platform priceNumber:" .. tostring(priceNumber))
  else
    local _localPrice = DataCenter.PayManager:GetLocalCurrency(param.productId) or ""
    self.sfsObj:PutUtfString("pay_PriceOfClosingCurrency", _localPrice)
    Logger.LogInfo("payios local priceNumber:" .. tostring(_localPrice))
  end
  if param.currencyCode then
    self.sfsObj:PutUtfString("pay_closingCurrency", param.currencyCode)
  else
    local _currency = DataCenter.PayManager:__GetLocalCurrencyCode() or ""
    self.sfsObj:PutUtfString("pay_closingCurrency", _currency)
  end
  if param.toUID ~= nil and param.toUID ~= "" then
    self.sfsObj:PutUtfString("toUID", param.toUID)
  end
  if param.subscribeUid ~= nil and param.subscribeUid ~= "" then
    self.sfsObj:PutUtfString("subscribeUid", param.subscribeUid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.usePush and t.usePush == true then
    return
  end
  DataCenter.PayManager:PayMessageHandle(t)
end

PayIOSMessage.OnCreate = OnCreate
PayIOSMessage.HandleMessage = HandleMessage
return PayIOSMessage
