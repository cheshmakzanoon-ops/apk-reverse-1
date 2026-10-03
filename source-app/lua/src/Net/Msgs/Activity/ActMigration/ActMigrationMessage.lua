local ActMigrationMessage = BaseClass("ActMigrationMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ActMigrationMsg, 1)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ActMigrationMsg, 0)
end

ActMigrationMessage.OnCreate = OnCreate
ActMigrationMessage.HandleMessage = HandleMessage
return ActMigrationMessage
