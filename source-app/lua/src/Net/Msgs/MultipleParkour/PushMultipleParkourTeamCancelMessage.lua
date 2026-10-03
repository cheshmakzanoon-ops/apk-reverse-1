local PushMultipleParkourTeamCancelMessage = BaseClass("PushMultipleParkourTeamCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushMultipleParkourTeamCancelMessage:OnCreate()
  base.OnCreate(self)
end

function PushMultipleParkourTeamCancelMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return PushMultipleParkourTeamCancelMessage
