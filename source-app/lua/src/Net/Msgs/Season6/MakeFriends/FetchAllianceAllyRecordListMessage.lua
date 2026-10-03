local FetchAllianceAllyRecordListMessage = BaseClass("FetchAllianceAllyRecordListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchAllianceAllyRecordListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchAllianceAllyRecordListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local dataList = t.list
  if dataList == nil then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.MFAllyMessageUpdate, dataList)
end

return FetchAllianceAllyRecordListMessage
