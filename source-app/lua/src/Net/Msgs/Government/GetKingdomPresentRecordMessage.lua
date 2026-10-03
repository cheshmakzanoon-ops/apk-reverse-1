local GetKingdomPresentRecordMessage = BaseClass("GetKingdomPresentRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId, throneType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("actType", throneType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:GetKingdomPresentRecordHandler(t)
end

GetKingdomPresentRecordMessage.OnCreate = OnCreate
GetKingdomPresentRecordMessage.HandleMessage = HandleMessage
return GetKingdomPresentRecordMessage
