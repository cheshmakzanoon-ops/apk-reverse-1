local PushDecorationShopGiftInfoMessage = BaseClass("PushDecorationShopGiftInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDecorationShopGiftInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushDecorationShopGiftInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.giftInfo then
    DataCenter.CommonShopManager:UpdateDecorationShopMessage(t.giftInfo)
  end
end

return PushDecorationShopGiftInfoMessage
