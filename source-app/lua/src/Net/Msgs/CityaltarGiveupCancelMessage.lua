local CityaltarGiveupCancelMessage = BaseClass("CityaltarGiveupCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarGiveupCancelMessage:OnCreate(uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", serverId)
end

function CityaltarGiveupCancelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return CityaltarGiveupCancelMessage
