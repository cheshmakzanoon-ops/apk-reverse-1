local KingdomPositionResignMessage = BaseClass("KingdomPositionResignMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomPositionResignMessage:OnCreate(param)
  base.OnCreate(self)
end

function KingdomPositionResignMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:kingdomPositionResignHandle(t)
end

return KingdomPositionResignMessage
