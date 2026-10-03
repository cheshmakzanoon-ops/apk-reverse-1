local AccountBindMessage = BaseClass("AccountBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    DataCenter.AccountManager:SetParam(param)
    self.sfsObj:PutUtfString("userName", param.userName)
  end
  self.sfsObj:PutUtfString("bind_with_device_id", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    if errorCode == "280049" then
      UIUtil.ShowTipsId("multibind_protect_desc01")
      Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(UITimeManager:GetInstance():GetServerTime()))
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
    return
  end
end

AccountBindMessage.OnCreate = OnCreate
AccountBindMessage.HandleMessage = HandleMessage
return AccountBindMessage
