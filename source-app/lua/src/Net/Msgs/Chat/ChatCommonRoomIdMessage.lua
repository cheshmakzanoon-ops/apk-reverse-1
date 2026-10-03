local ChatCommonRoomIdMessage = BaseClass("ChatCommonRoomIdMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, messageType)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  ChatManager2:GetInstance().Room:HandleServerRoomUpdate(t)
end

ChatCommonRoomIdMessage.OnCreate = OnCreate
ChatCommonRoomIdMessage.HandleMessage = HandleMessage
return ChatCommonRoomIdMessage
