local DecorationShopGiftRequestInfoMessage = BaseClass("DecorationShopGiftRequestInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DecorationShopGiftRequestInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function DecorationShopGiftRequestInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CommonShopManager:UpdateDecorationShopMessage(t.giftInfo)
  end
end

return DecorationShopGiftRequestInfoMessage
