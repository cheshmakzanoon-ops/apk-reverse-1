local StoreCurrencyInitMessage = BaseClass("StoreCurrencyInitMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, storeCountry, storeCurrency)
  base.OnCreate(self)
  if not string.IsNullOrEmpty(storeCountry) then
    self.sfsObj:PutUtfString("storeCountry", storeCountry)
  end
  self.sfsObj:PutUtfString("storeCurrency", storeCurrency)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if not errCode then
    local storeCountry = t.storeCountry
    local storeCurrency = t.storeCurrency
    if not string.IsNullOrEmpty(storeCountry) or not string.IsNullOrEmpty(storeCurrency) then
      LuaEntry.Player:UpdateStoreInfo(storeCountry, storeCurrency)
    end
    if t.goldBrickSwitch ~= nil then
      LuaEntry.Player:SetGoldBrickSwitch(t.goldBrickSwitch == 1)
    end
    DataCenter.PaymentMethodManager:ApplyExternalCheckoutConfigUpdate(t)
    EventManager:GetInstance():Broadcast(EventId.PlayerInfoUpdated)
  end
end

StoreCurrencyInitMessage.OnCreate = OnCreate
StoreCurrencyInitMessage.HandleMessage = HandleMessage
return StoreCurrencyInitMessage
