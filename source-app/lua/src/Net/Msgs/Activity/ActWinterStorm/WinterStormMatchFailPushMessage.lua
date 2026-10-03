local WinterStormMatchFailPushMessage = BaseClass("WinterStormMatchFailPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleMatchFailPush(t)
  end
end

WinterStormMatchFailPushMessage.OnCreate = OnCreate
WinterStormMatchFailPushMessage.HandleMessage = HandleMessage
return WinterStormMatchFailPushMessage
