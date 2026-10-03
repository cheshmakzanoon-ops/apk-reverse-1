local WinterStormMatchEnterPushMessage = BaseClass("WinterStormMatchEnterPushMessage", SFSBaseMessage)
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
    DataCenter.ActWinterStormManager:HandleEnterPush(t)
  end
end

WinterStormMatchEnterPushMessage.OnCreate = OnCreate
WinterStormMatchEnterPushMessage.HandleMessage = HandleMessage
return WinterStormMatchEnterPushMessage
