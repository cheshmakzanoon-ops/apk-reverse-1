local AllianceBossS0TopListMessage = BaseClass("AllianceBossS0TopListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0TopListMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossS0TopListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossTopListGot, message)
end

return AllianceBossS0TopListMessage
