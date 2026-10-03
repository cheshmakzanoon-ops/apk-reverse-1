local LWSeasonTrendRankRewardMessage = BaseClass("LWSeasonTrendRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("trend_id", tonumber(configId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.LWSeasonTrendsManager:HandleSeasonTrendsRankRewardInfo(t)
end

LWSeasonTrendRankRewardMessage.OnCreate = OnCreate
LWSeasonTrendRankRewardMessage.HandleMessage = HandleMessage
return LWSeasonTrendRankRewardMessage
