local WinterStormPushMatchForbidMessage = BaseClass("WinterStormPushMatchForbidMessage", SFSBaseMessage)
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
    DataCenter.ActWinterStormManager:HandleMatchForbid(t)
  end
end

WinterStormPushMatchForbidMessage.OnCreate = OnCreate
WinterStormPushMatchForbidMessage.HandleMessage = HandleMessage
return WinterStormPushMatchForbidMessage
