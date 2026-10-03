local BargainHelpMessage = BaseClass("BargainHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BargainHelpMessage:OnCreate(uuid, seqId, activityId, roomId, chatSeqId, senderUid, type)
  base.OnCreate(self)
  if uuid then
    self.sfsObj:PutUtfString("uuid", uuid)
  end
  if seqId then
    self.sfsObj:PutUtfString("seqId", seqId)
  end
  if activityId then
    self.sfsObj:PutInt("activityId", activityId)
  end
  if roomId then
    self.sfsObj:PutUtfString("roomId", roomId)
  end
  if chatSeqId then
    self.sfsObj:PutUtfString("chatSeqId", tostring(chatSeqId))
  end
  if senderUid then
    self.sfsObj:PutUtfString("senderUid", tostring(senderUid))
  end
  if type then
    self.sfsObj:PutInt("type", type)
  end
end

function BargainHelpMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActBargainShopData:HelpBargain(message)
end

return BargainHelpMessage
