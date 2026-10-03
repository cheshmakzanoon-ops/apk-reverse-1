local ActivityGoodsExchangeListMessage = BaseClass("ActivityGoodsExchangeListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityGoodsExchangeListMessage:OnCreate()
  base.OnCreate(self)
end

function ActivityGoodsExchangeListMessage:HandleMessage(t)
  base.HandleMessage(message)
  if t.errorCode == nil then
    DataCenter.ItemExchangeManager:SetItemExchangeServerData(t)
  end
end

return ActivityGoodsExchangeListMessage
