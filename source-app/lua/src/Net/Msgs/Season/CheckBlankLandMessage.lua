local CheckBlankLandMessage = BaseClass("CheckBlankLandMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckBlankLandMessage:OnCreate(point, serverId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", point)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId or 0)
end

function CheckBlankLandMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.CheckBlankLandResult, t)
end

return CheckBlankLandMessage
