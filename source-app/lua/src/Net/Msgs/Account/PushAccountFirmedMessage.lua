local PushAccountFirmedMessage = BaseClass("PushAccountFirmedMessage", SFSBaseMessage)
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
  DataCenter.AccountManager:PushAccountFirmedHandle(t)
  EventManager:GetInstance():Broadcast(EventId.AccountSettingAnonymityChange)
end

PushAccountFirmedMessage.OnCreate = OnCreate
PushAccountFirmedMessage.HandleMessage = HandleMessage
return PushAccountFirmedMessage
