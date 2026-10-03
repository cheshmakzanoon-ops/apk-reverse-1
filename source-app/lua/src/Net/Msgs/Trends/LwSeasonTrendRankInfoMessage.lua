local LwSeasonTrendRankInfoMessage = BaseClass("LwSeasonTrendRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, configId, rankId)
  base.OnCreate(self)
  self.sfsObj:PutInt("trend_id", tonumber(configId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.LWSeasonTrendsManager:HandleSeasonTrendsRankInfo(t)
end

LwSeasonTrendRankInfoMessage.OnCreate = OnCreate
LwSeasonTrendRankInfoMessage.HandleMessage = HandleMessage
return LwSeasonTrendRankInfoMessage
