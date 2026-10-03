local PushMultipleRoomMessage = BaseClass("PushMultipleRoomMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleRoomMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleRoomMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.MultipleParkourManager:HandlePushMultipleRoom(message)
end

return PushMultipleRoomMessage
