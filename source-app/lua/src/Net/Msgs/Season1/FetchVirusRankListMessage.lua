local FetchVirusRankListMessage = BaseClass("FetchVirusRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchVirusRankListMessage:OnCreate(VirusType, SubType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", VirusType)
  self.sfsObj:PutInt("subtype", SubType)
end

function FetchVirusRankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.type ~= nil and t.subtype ~= nil then
    t.requestTime = UITimeManager:GetInstance():GetServerTime()
    EventManager:GetInstance():Broadcast(EventId.LWSeasonVirusRankListUpdate, t)
  end
end

return FetchVirusRankListMessage
