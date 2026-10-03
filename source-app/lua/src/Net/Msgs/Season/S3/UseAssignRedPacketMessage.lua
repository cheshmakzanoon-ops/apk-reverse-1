local UseAssignRedPacketMessage = BaseClass("UseAssignRedPacketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseAssignRedPacketMessage:OnCreate(uuid, chatType, copy, copyChatType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("chatType", chatType)
  self.sfsObj:PutBool("copy", copy)
  self.sfsObj:PutInt("copyChatType", copyChatType)
end

function UseAssignRedPacketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleUseRedPacket(t)
  end
end

return UseAssignRedPacketMessage
