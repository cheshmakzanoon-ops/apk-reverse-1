local LWSeasonTrendRewardMessage = BaseClass("LWSeasonTrendRewardMessage", SFSBaseMessage)
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
  local off_seaon = 0
  if t.off_seaon then
    off_seaon = t.off_seaon
  end
  if off_seaon <= 0 then
    DataCenter.LWSeasonTrendsManager:HandleSeasonTrendsReward(t)
  else
    DataCenter.ActTrendsDataManager:HandleSeasonTrendsReward(t)
  end
end

LWSeasonTrendRewardMessage.OnCreate = OnCreate
LWSeasonTrendRewardMessage.HandleMessage = HandleMessage
return LWSeasonTrendRewardMessage
