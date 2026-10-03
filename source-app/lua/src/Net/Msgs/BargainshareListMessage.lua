local BargainshareListMessage = BaseClass("BargainshareListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BargainshareListMessage:OnCreate(param, otherUid, type, roomId)
  base.OnCreate(self)
  if param then
    if param.itemUid then
      self.sfsObj:PutUtfString("uuid", param.itemUid)
    end
    if param.activityId then
      self.sfsObj:PutInt("activityId", param.activityId)
    end
    if param.itemId then
      self.sfsObj:PutUtfString("itemId", param.itemId)
    end
  end
  if otherUid then
    self.sfsObj:PutUtfString("otherUid", otherUid)
  end
  if type then
    self.sfsObj:PutInt("type", type)
  end
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
end

function BargainshareListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActBargainShopData:SendShareChatRoomMessage(message)
end

return BargainshareListMessage
