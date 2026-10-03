local CityaltarGiveupMessage = BaseClass("CityaltarGiveupMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CityaltarGiveupMessage:OnCreate(uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", serverId)
end

function CityaltarGiveupMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return CityaltarGiveupMessage
