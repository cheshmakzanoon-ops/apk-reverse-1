local PushMultipleParkourRoomPlayerMessage = BaseClass("PushMultipleParkourRoomPlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleParkourRoomPlayerMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleParkourRoomPlayerMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.MultipleParkourManager:HandlePushMultipleRoomPlayer(message)
end

return PushMultipleParkourRoomPlayerMessage
