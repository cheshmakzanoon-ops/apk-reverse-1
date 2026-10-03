local FetchSeasonTrendFirstRankPlayerMessage = BaseClass("FetchSeasonTrendFirstRankPlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonTrendFirstRankPlayerMessage:OnCreate(query_ids)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("ids", query_ids)
end

function FetchSeasonTrendFirstRankPlayerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWSeasonTrendsManager:OnTrendFirstRankMessage(t)
  end
end

return FetchSeasonTrendFirstRankPlayerMessage
