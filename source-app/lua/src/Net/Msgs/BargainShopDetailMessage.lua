local BargainShopDetailMessage = BaseClass("BargainShopDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BargainShopDetailMessage:OnCreate(itemUid, activityId)
  base.OnCreate(self)
  if itemUid then
    self.sfsObj:PutUtfString("uuid", itemUid)
  end
  if activityId then
    self.sfsObj:PutInt("activityId", activityId)
  end
end

function BargainShopDetailMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActBargainShopData:UpdateShopPropInfo(message)
end

return BargainShopDetailMessage
