local GetKingOccupyProgressMessage = BaseClass("GetKingOccupyProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, serverId)
  base.OnCreate(self)
  if serverId == nil then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    self.sfsObj:PutInt("serverId", toInt(mySourceServerId))
  else
    self.sfsObj:PutInt("serverId", toInt(serverId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:KingOccupyProgressHandler(t)
end

GetKingOccupyProgressMessage.OnCreate = OnCreate
GetKingOccupyProgressMessage.HandleMessage = HandleMessage
return GetKingOccupyProgressMessage
