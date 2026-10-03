local NewBeeMigrateMessage = BaseClass("NewBeeMigrateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, accept)
  base.OnCreate(self)
  self.sfsObj:PutBool("accept", accept)
  Logger.LogInfo("[NewBeeMigrateMessage] accept=", tostring(accept))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  local status = t.status or 1
  EventManager:GetInstance():Broadcast(EventId.NewBeeMigrateMsg, status)
end

NewBeeMigrateMessage.OnCreate = OnCreate
NewBeeMigrateMessage.HandleMessage = HandleMessage
return NewBeeMigrateMessage
