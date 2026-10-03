local ActMigrationGiveUpMessage = BaseClass("ActMigrationGiveUpMessage", SFSBaseMessage)
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
  DataCenter.ActMigrationManager:HandleApply(false)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationMsg, 0)
end

ActMigrationGiveUpMessage.OnCreate = OnCreate
ActMigrationGiveUpMessage.HandleMessage = HandleMessage
return ActMigrationGiveUpMessage
