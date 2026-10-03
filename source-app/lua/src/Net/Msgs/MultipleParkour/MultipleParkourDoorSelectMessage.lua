local MultipleParkourDoorSelectMessage = BaseClass("MultipleParkourDoorSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function MultipleParkourDoorSelectMessage:OnCreate(roomId, select, curTotalLevel)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("roomId", tostring(roomId))
  self.sfsObj:PutInt("select", tonumber(select))
  self.sfsObj:PutInt("curTotalLevel", tonumber(curTotalLevel))
end

function MultipleParkourDoorSelectMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
end

return MultipleParkourDoorSelectMessage
