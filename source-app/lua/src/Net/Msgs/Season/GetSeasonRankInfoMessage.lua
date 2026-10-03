local GetSeasonRankInfoMessage = BaseClass("GetSeasonRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonRankInfoMessage:OnCreate(rank_type, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("rank_type", rank_type)
  self.sfsObj:PutInt("pageSize", pageSize or 100)
end

function GetSeasonRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager:UpdateSeasonRankDataCache(t)
  EventManager:GetInstance():Broadcast(EventId.SeasonRankUpdate, t)
end

return GetSeasonRankInfoMessage
