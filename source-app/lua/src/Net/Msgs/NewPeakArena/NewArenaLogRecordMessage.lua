local NewArenaLogRecordMessage = BaseClass("NewArenaLogRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.NewPeakArenaManager:NewArenaLogRecordHandler(t)
    else
      EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetMessageError)
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaLogRecordMessage.OnCreate = OnCreate
NewArenaLogRecordMessage.HandleMessage = HandleMessage
return NewArenaLogRecordMessage
