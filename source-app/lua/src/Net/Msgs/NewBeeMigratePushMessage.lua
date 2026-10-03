local NewBeeMigratePushMessage = BaseClass("NewBeeMigratePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, accept)
  base.OnCreate(self)
  self.sfsObj:PutBool("accept", accept)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.NewBeeMigratePushMsg)
end

NewBeeMigratePushMessage.OnCreate = OnCreate
NewBeeMigratePushMessage.HandleMessage = HandleMessage
return NewBeeMigratePushMessage
