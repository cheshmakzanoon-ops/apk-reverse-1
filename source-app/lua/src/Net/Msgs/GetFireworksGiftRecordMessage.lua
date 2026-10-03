local GetFireworksGiftRecordMessage = BaseClass("GetFireworksGiftRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetFireworksGiftRecordMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("ownerUid", param.ownerUid)
end

function GetFireworksGiftRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkGiftRecord)
  else
    EventManager:GetInstance():Broadcast(EventId.FireworkGetFireworksGiftRecord, t)
  end
end

return GetFireworksGiftRecordMessage
