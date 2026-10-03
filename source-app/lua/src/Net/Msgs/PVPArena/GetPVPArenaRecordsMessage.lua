local GetPVPArenaRecordsMessage = BaseClass("GetPVPArenaRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetMessageError)
  else
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetRecords, t)
  end
end

GetPVPArenaRecordsMessage.OnCreate = OnCreate
GetPVPArenaRecordsMessage.HandleMessage = HandleMessage
return GetPVPArenaRecordsMessage
