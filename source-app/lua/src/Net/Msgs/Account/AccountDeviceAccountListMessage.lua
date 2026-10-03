local AccountDeviceAccountListMessage = BaseClass("AccountDeviceAccountListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AccountDeviceAccountListMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("deviceId", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

function AccountDeviceAccountListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AccountDeviceAccountListMessage
