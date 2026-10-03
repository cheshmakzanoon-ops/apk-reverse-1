local PushDailyPackageShowMessage = BaseClass("PushDailyPackageShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DailyPackageManager:UpdateReadedIds(t)
  end
end

PushDailyPackageShowMessage.OnCreate = OnCreate
PushDailyPackageShowMessage.HandleMessage = HandleMessage
return PushDailyPackageShowMessage
