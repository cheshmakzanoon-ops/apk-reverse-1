local ActMigrationShareCDPushMessage = BaseClass("ActMigrationShareCDPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local shareCdTime = t.shareCdTime
  if shareCdTime then
    DataCenter.ActMigrationManager:UpdateShareCDTime(shareCdTime)
  end
end

ActMigrationShareCDPushMessage.OnCreate = OnCreate
ActMigrationShareCDPushMessage.HandleMessage = HandleMessage
return ActMigrationShareCDPushMessage
