local FetchOutpostListMessage = BaseClass("FetchOutpostListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchOutpostListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.outpostList then
    DataCenter.SeasonDataManager.OccupyOutpostList = t.outpostList
    EventManager:GetInstance():Broadcast(EventId.OutpostListUpdate)
  end
end

return FetchOutpostListMessage
