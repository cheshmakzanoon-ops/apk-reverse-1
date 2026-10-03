local AccountLoginNewMessage = BaseClass("AccountLoginNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param, type)
  base.OnCreate(self)
  if param ~= nil then
    DataCenter.AccountManager:SetParam(param)
    if param.googleAccount then
      self.sfsObj:PutInt("type", 2)
      self.sfsObj:PutUtfString("googleAccount", param.googleAccount)
      if param.idToken then
        self.sfsObj:PutUtfString("idToken", param.idToken)
      end
    elseif param.pgs_id then
      self.sfsObj:PutInt("type", 5)
      if not string.IsNullOrEmpty(param.pgs_id) then
        self.sfsObj:PutUtfString("pgs_id", param.pgs_id)
      end
      if not string.IsNullOrEmpty(param.auth_code) then
        self.sfsObj:PutUtfString("auth_code", param.auth_code)
      end
    elseif param.pfId then
      self.sfsObj:PutInt("type", 4)
      self.sfsObj:PutUtfString("pfId", param.pfId)
    else
      self.sfsObj:PutInt("type", 0)
      self.sfsObj:PutUtfString("mail", param.mail)
      self.sfsObj:PutUtfString("verifyCode", param.code)
    end
  else
    local targetType = 1
    if type then
      targetType = type
    end
    self.sfsObj:PutInt("type", targetType)
  end
  if CS.SDKManager.IS_IPhonePlayer() then
    self.sfsObj:PutUtfString("pf", "AppStore")
  elseif CS.SDKManager.IS_Android() then
    self.sfsObj:PutUtfString("pf", "market_global")
  end
  self.sfsObj:PutUtfString("deviceId", CS.GameEntry.Device:GetDeviceUid())
  self.sfsObj:PutUtfString("airKey", CS.GameEntry.Device:GetDeviceUid_Transcoding())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
end

AccountLoginNewMessage.OnCreate = OnCreate
AccountLoginNewMessage.HandleMessage = HandleMessage
return AccountLoginNewMessage
