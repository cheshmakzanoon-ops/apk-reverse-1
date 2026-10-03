local AccountDeviceAccountDelMessage = BaseClass("AccountDeviceAccountDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AccountDeviceAccountDelMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("deviceId", param)
  self.sfsObj:PutUtfString("selfDeviceId", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:SetDeviceUidToTranscoding(param))
  self.sfsObj:PutUtfString("selfAirKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

function AccountDeviceAccountDelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return AccountDeviceAccountDelMessage
