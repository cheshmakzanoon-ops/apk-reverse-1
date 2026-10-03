local PushAccountDeviceDelMessage = BaseClass("PushAccountDeviceDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAccountDeviceDelMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAccountDeviceDelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("device_manage_tips01")
    local myselfDeviceId = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, "")
    local myselfAirKey = CS.GameEntry.Device:SetDeviceUidToTranscoding(myselfDeviceId)
    if t.deviceId and t.deviceId == myselfDeviceId or t.airKey and t.airKey == myselfAirKey then
      Logger.LogInfo("[AT]RemoveAll_PushAccDeviceDelMsg")
      CS.AccountCredentialManager.ClearAll()
      CS.ApplicationLaunch.Instance:ReloadGame()
    else
      SFSNetwork.SendMessage(MsgDefines.AccountDeviceAccountList)
    end
  end
end

return PushAccountDeviceDelMessage
