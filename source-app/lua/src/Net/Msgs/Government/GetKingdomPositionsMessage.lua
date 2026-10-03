local GetKingdomPositionsMessage = BaseClass("GetKingdomPositionsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:GetKingdomPositionsHandler(t)
end

GetKingdomPositionsMessage.OnCreate = OnCreate
GetKingdomPositionsMessage.HandleMessage = HandleMessage
return GetKingdomPositionsMessage
