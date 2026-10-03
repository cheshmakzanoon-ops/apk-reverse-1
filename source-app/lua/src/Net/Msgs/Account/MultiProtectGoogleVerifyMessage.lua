local MultiProtectGoogleVerifyMessage = BaseClass("MultiProtectGoogleVerifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MultiProtectGoogleVerifyMessage:OnCreate(param)
  base.OnCreate(self)
  if CS.SDKManager.IS_IPhonePlayer() then
    self.sfsObj:PutUtfString("pf", "AppStore")
    local gpUserId = DataCenter.AccountManager.GameCenterAccount.userId
    if not string.IsNullOrEmpty(gpUserId) then
      self.sfsObj:PutUtfString("gpUserId", gpUserId)
    end
  elseif CS.SDKManager.IS_Android() then
    self.sfsObj:PutUtfString("pf", "market_global")
    local gpUserId = DataCenter.AccountManager.GoogleSignAccount.userId
    if not string.IsNullOrEmpty(gpUserId) then
      self.sfsObj:PutUtfString("gpUserId", gpUserId)
    end
    local playerId = DataCenter.AccountManager.PlayGamesAccount.userId
    if not string.IsNullOrEmpty(playerId) then
      self.sfsObj:PutUtfString("pgs_id", playerId)
    end
  end
  self.sfsObj:PutUtfString("deviceId", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

function MultiProtectGoogleVerifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local expireTime = t.expireTime
    if not string.IsNullOrEmpty(expireTime) then
      CS.GameEntry.Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(expireTime))
    end
  end
end

return MultiProtectGoogleVerifyMessage
