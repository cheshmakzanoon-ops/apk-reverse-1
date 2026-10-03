local GetCrossKingOccupyProgressMessage = BaseClass("GetCrossKingOccupyProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossKingOccupyProgressMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId or LuaEntry.Player:GetCurServerId())
end

function GetCrossKingOccupyProgressMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.GovernmentManager:CrossKingOccupyProgressHandler(t)
end

return GetCrossKingOccupyProgressMessage
