local ActMigrationMarkSearchNamePushMessage = BaseClass("ActMigrationMarkSearchNamePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationMarkPlayerSearchUpdate, t.uids)
end

ActMigrationMarkSearchNamePushMessage.OnCreate = OnCreate
ActMigrationMarkSearchNamePushMessage.HandleMessage = HandleMessage
return ActMigrationMarkSearchNamePushMessage
