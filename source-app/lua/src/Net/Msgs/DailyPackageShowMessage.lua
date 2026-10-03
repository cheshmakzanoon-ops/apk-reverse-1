local DailyPackageShowMessage = BaseClass("DailyPackageShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
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

DailyPackageShowMessage.OnCreate = OnCreate
DailyPackageShowMessage.HandleMessage = HandleMessage
return DailyPackageShowMessage
