local GetUserReceiveGiftMessage = BaseClass("GetUserReceiveGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUserReceiveGiftMessage:OnCreate(targetUid, recordType, uuid, group)
  base.OnCreate(self)
  if targetUid then
    self.sfsObj:PutUtfString("targetUid", tostring(targetUid))
  end
  if recordType then
    self.sfsObj:PutInt("recordType", recordType)
  end
  if uuid then
    self.sfsObj:PutUtfString("uuid", tostring(uuid))
  end
  if group then
    self.sfsObj:PutUtfString("group", tostring(group))
  end
end

function GetUserReceiveGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleReceiveGift(t)
  end
end

return GetUserReceiveGiftMessage
