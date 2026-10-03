local GetServerStateMessage = BaseClass("GetServerStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetServerStateMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function GetServerStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.CheckServerOK, errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.CheckServerOK, errCode)
  end
end

return GetServerStateMessage
