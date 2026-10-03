local DailyPackageSelectMessage = BaseClass("DailyPackageSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("id", tostring(id))
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

DailyPackageSelectMessage.OnCreate = OnCreate
DailyPackageSelectMessage.HandleMessage = HandleMessage
return DailyPackageSelectMessage
