local PushRoomModifyNameMessage = BaseClass("PushRoomModifyNameMessage", SFSBaseMessage)

local function OnCreate(self, param)
end

local function HandleMessage(self, msg)
  self.super.HandleMessage(self)
  if msg.errorCode ~= nil then
    UIUtil.ShowErrorCodeTips(msg)
  end
end

PushRoomModifyNameMessage.OnCreate = OnCreate
PushRoomModifyNameMessage.HandleMessage = HandleMessage
return PushRoomModifyNameMessage
