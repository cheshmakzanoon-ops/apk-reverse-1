local AccountVerifyMessage = BaseClass("AccountVerifyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, code)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("verifyCode", code)
  self.sfsObj:PutUtfString("bind_with_device_id", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
end

AccountVerifyMessage.OnCreate = OnCreate
AccountVerifyMessage.HandleMessage = HandleMessage
return AccountVerifyMessage
