local MultipleParkourDoorExitMessage = BaseClass("MultipleParkourDoorExitMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourDoorExitMessage:OnCreate(roomId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", tostring(roomId))
end

function MultipleParkourDoorExitMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if not message.result or tonumber(message.result) == 1 then
  end
end

return MultipleParkourDoorExitMessage
