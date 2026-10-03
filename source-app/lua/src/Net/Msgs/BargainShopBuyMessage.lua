local BargainShopBuyMessage = BaseClass("BargainShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BargainShopBuyMessage:OnCreate(activityId, itemUid, num)
  base.OnCreate(self)
  if itemUid then
    self.sfsObj:PutUtfString("uuid", itemUid)
  end
  if activityId then
    self.sfsObj:PutInt("activityId", activityId)
  end
  if num then
    self.sfsObj:PutInt("num", num)
  end
end

function BargainShopBuyMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActBargainShopData:OnBuyItem(message)
end

return BargainShopBuyMessage
