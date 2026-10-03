local GetAllianceSeasonScoreRankRewardMessage = BaseClass("GetAllianceSeasonScoreRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.GetAllianceSeasonScoreRankReward, t)
end

GetAllianceSeasonScoreRankRewardMessage.OnCreate = OnCreate
GetAllianceSeasonScoreRankRewardMessage.HandleMessage = HandleMessage
return GetAllianceSeasonScoreRankRewardMessage
