local DailyPackageInfoMessage = BaseClass("DailyPackageInfoMessage", SFSBaseMessage)
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
    DataCenter.DailyPackageManager:UpdateData(t)
  end
end

DailyPackageInfoMessage.OnCreate = OnCreate
DailyPackageInfoMessage.HandleMessage = HandleMessage
return DailyPackageInfoMessage
