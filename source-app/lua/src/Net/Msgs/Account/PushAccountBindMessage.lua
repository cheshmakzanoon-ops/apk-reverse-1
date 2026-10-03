local PushAccountBindMessage = BaseClass("PushAccountBindMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local expireTime = t.expireTime
  if not string.IsNullOrEmpty(expireTime) then
    CS.GameEntry.Setting:SetPrivateString("DoubleChannelVerifyExpireTime", tostring(expireTime))
  end
  local emailExpireTime = t.emailExpireTime
  if not string.IsNullOrEmpty(emailExpireTime) then
    CS.GameEntry.Setting:SetPrivateString("LW_EmailResendExpireTime", tostring(emailExpireTime))
  end
  DataCenter.AccountManager:AccountBindHandle(t)
end

PushAccountBindMessage.OnCreate = OnCreate
PushAccountBindMessage.HandleMessage = HandleMessage
return PushAccountBindMessage
