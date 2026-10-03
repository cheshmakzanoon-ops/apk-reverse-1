local MultipleParkourTeamCancelMessage = BaseClass("MultipleParkourTeamCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourTeamCancelMessage:OnCreate(roomId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", tostring(roomId))
end

function MultipleParkourTeamCancelMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return MultipleParkourTeamCancelMessage
