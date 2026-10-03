local GaleArenaLogRecordMessage = BaseClass("GaleArenaLogRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewGaleArenaManager:NewArenaLogRecordHandler(t)
    else
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetMessageError)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaLogRecordMessage.OnCreate = OnCreate
GaleArenaLogRecordMessage.HandleMessage = HandleMessage
return GaleArenaLogRecordMessage
