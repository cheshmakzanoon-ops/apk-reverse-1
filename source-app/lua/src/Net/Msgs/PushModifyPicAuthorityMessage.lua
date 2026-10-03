local PushModifyPicAuthorityMessage = BaseClass("PushModifyPicAuthorityMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, stationId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  LuaEntry.Player:UpdateSendCustomHead(t)
end

PushModifyPicAuthorityMessage.OnCreate = OnCreate
PushModifyPicAuthorityMessage.HandleMessage = HandleMessage
return PushModifyPicAuthorityMessage
