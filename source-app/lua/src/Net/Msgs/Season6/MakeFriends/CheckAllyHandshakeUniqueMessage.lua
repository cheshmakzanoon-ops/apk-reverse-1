local CheckAllyHandshakeUniqueMessage = BaseClass("CheckAllyHandshakeUniqueMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckAllyHandshakeUniqueMessage:OnCreate(cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
end

function CheckAllyHandshakeUniqueMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.isUnique ~= nil then
    DataCenter.SeasonAllyFriendManager:SetHandshakeUnique(t.isUnique)
    EventManager:GetInstance():Broadcast(EventId.MFAllyHandshakeUnique, t.isUnique)
  end
end

return CheckAllyHandshakeUniqueMessage
