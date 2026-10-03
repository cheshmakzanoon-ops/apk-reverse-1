local PushDefenceWallUpdateMessage = BaseClass("PushDefenceWallUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.resource ~= nil then
    LuaEntry.Resource:UpdateResource(t.resource)
  end
  DataCenter.DefenceWallDataManager:UpdateDefenceWallData(t.defend_wall)
end

PushDefenceWallUpdateMessage.OnCreate = OnCreate
PushDefenceWallUpdateMessage.HandleMessage = HandleMessage
return PushDefenceWallUpdateMessage
