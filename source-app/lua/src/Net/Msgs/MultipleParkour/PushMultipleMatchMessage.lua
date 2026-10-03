local PushMultipleMatchMessage = BaseClass("PushMultipleMatchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleMatchMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleMatchMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.MultipleParkourManager:HandlePushMultipleMatch(message)
end

return PushMultipleMatchMessage
