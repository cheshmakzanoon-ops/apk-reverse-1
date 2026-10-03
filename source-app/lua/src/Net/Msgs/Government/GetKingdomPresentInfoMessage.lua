local GetKingdomPresentInfoMessage = BaseClass("GetKingdomPresentInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId, throneType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("actType", throneType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:GetKingdomPresentInfoHandler(t)
end

GetKingdomPresentInfoMessage.OnCreate = OnCreate
GetKingdomPresentInfoMessage.HandleMessage = HandleMessage
return GetKingdomPresentInfoMessage
