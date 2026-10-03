local WinterStormMatchPushMessage = BaseClass("WinterStormMatchPushMessage", SFSBaseMessage)
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
    DataCenter.ActWinterStormManager:HandleMatchPush(t)
  end
end

WinterStormMatchPushMessage.OnCreate = OnCreate
WinterStormMatchPushMessage.HandleMessage = HandleMessage
return WinterStormMatchPushMessage
