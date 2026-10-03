local MultipleParkourJoinTeamMessage = BaseClass("MultipleParkourJoinTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourJoinTeamMessage:OnCreate(roomId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", tostring(roomId))
end

function MultipleParkourJoinTeamMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return MultipleParkourJoinTeamMessage
