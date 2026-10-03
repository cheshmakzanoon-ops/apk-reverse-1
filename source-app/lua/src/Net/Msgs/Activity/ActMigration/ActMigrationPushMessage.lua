local ActMigrationPushMessage = BaseClass("ActMigrationPushMessage", SFSBaseMessage)
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
  EventManager:GetInstance():Broadcast(EventId.ActMigrationPushMsg)
end

ActMigrationPushMessage.OnCreate = OnCreate
ActMigrationPushMessage.HandleMessage = HandleMessage
return ActMigrationPushMessage
