local GetKingdomBadgesMessage = BaseClass("GetKingdomBadgesMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetKingdomBadgesMessage:OnCreate()
  base.OnCreate(self)
end

function GetKingdomBadgesMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:GetKingdomBadgesHandler(t)
end

return GetKingdomBadgesMessage
