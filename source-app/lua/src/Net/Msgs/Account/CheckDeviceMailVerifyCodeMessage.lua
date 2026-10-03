local CheckDeviceMailVerifyCodeMessage = BaseClass("CheckDeviceMailVerifyCodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CheckDeviceMailVerifyCodeMessage:OnCreate(param)
  base.OnCreate(self)
  if CS.SDKManager.IS_IPhonePlayer() then
    self.sfsObj:PutUtfString("pf", "AppStore")
  elseif CS.SDKManager.IS_Android() then
    self.sfsObj:PutUtfString("pf", "market_global")
  end
  self.sfsObj:PutUtfString("mail", param.mail or "")
  self.sfsObj:PutUtfString("verifyCode", param.code or "")
  self.sfsObj:PutUtfString("type", DataCenter.AccountManager:GetMailVerifyCodeType())
  self.sfsObj:PutUtfString("deviceId", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

function CheckDeviceMailVerifyCodeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
    local expireTime = t.expireTime
    local oType = DataCenter.AccountManager:GetMailVerifyCodeType()
    if oType == "bind" then
      if not string.IsNullOrEmpty(expireTime) then
        CS.GameEntry.Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(expireTime))
      end
      UIUtil.ShowTipsId("multibind_protect_verity01")
    else
      if not string.IsNullOrEmpty(expireTime) then
        CS.GameEntry.Setting:SetPrivateString("DeviceManageMailVerifyExpireTime", tostring(expireTime))
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeviceManage)
    end
  end
end

return CheckDeviceMailVerifyCodeMessage
