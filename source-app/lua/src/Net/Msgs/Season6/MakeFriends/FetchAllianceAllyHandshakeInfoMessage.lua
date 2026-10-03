local FetchAllianceAllyHandshakeInfoMessage = BaseClass("FetchAllianceAllyHandshakeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyHandshakeInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchAllianceAllyHandshakeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.myAlliance and t.allyAlliance then
    DataCenter.SeasonAllyFriendManager:SetHandshakeInfo(t)
    EventManager:GetInstance():Broadcast(EventId.MFAllyHandshakeInfoUpdate, t)
  end
end

return FetchAllianceAllyHandshakeInfoMessage
