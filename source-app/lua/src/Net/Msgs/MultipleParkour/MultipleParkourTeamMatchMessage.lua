local MultipleParkourTeamMatchMessage = BaseClass("MultipleParkourTeamMatchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourTeamMatchMessage:OnCreate()
  base.OnCreate(self)
end

function MultipleParkourTeamMatchMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return MultipleParkourTeamMatchMessage
