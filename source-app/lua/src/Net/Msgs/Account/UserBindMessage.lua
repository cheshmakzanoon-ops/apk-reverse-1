local UserBindMessage = BaseClass("UserBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  DataCenter.UserBindManager:SetParam(param)
  if param ~= nil then
    self.sfsObj:PutInt("optType", param.optType)
    if not string.IsNullOrEmpty(param.googlePlay) then
      self.sfsObj:PutUtfString("googlePlay", param.googlePlay)
    end
    if not string.IsNullOrEmpty(param.googlePlayName) then
      self.sfsObj:PutUtfString("googleAccountName", param.googlePlayName)
    end
    if not string.IsNullOrEmpty(param.pgs_id) then
      self.sfsObj:PutUtfString("pgs_id", param.pgs_id)
    end
    if not string.IsNullOrEmpty(param.pgs_name) then
      self.sfsObj:PutUtfString("pgs_name", param.pgs_name)
    end
    if not string.IsNullOrEmpty(param.auth_code) then
      self.sfsObj:PutUtfString("auth_code", param.auth_code)
    end
    if not string.IsNullOrEmpty(param.idToken) then
      self.sfsObj:PutUtfString("idToken", param.idToken)
    end
    if CS.SDKManager.IS_IPhonePlayer() then
      self.sfsObj:PutUtfString("pf", "AppStore")
    elseif CS.SDKManager.IS_Android() then
      self.sfsObj:PutUtfString("pf", "market_global")
    end
    self.sfsObj:PutUtfString("bind_with_device_id", CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""))
    self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    if errorCode == "280049" then
      UIUtil.ShowTipsId("multibind_protect_desc02")
      Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(UITimeManager:GetInstance():GetServerTime()))
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
    return
  end
  local expireTime = t.expireTime
  if not string.IsNullOrEmpty(expireTime) then
    CS.GameEntry.Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(expireTime))
  end
  DataCenter.UserBindManager:UserBindHandle(t)
  EventManager:GetInstance():Broadcast(EventId.AccountSettingAnonymityChange)
end

UserBindMessage.OnCreate = OnCreate
UserBindMessage.HandleMessage = HandleMessage
return UserBindMessage
