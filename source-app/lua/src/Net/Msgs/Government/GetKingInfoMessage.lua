local GetKingInfoMessage = BaseClass("GetKingInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", toInt(serverId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:GetKingInfoHandler(t)
  DataCenter.ActMigrationManager:OnGetKingInfoHandler(t)
end

GetKingInfoMessage.OnCreate = OnCreate
GetKingInfoMessage.HandleMessage = HandleMessage
return GetKingInfoMessage
