local LeaveWorldMessage = BaseClass("LeaveWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
end

LeaveWorldMessage.OnCreate = OnCreate
LeaveWorldMessage.HandleMessage = HandleMessage
return LeaveWorldMessage
