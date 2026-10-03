local PushMultipleParkourPlayerEndMessage = BaseClass("PushMultipleParkourPlayerEndMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleParkourPlayerEndMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleParkourPlayerEndMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.MultipleParkourManager:HandlePushMultiplePlayerEnd(message)
end

return PushMultipleParkourPlayerEndMessage
