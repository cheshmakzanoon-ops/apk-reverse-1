local PushPicVerUpdateMessage = BaseClass("PushPicVerUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local uid = message.uid
  if uid ~= LuaEntry.Player:GetUid() then
    return
  end
  LuaEntry.Player:UpdatePic(message)
end

PushPicVerUpdateMessage.OnCreate = OnCreate
PushPicVerUpdateMessage.HandleMessage = HandleMessage
return PushPicVerUpdateMessage
