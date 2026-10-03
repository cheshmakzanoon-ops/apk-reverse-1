local GetSeasonVirusAchievementRewardInfoMessage = BaseClass("GetSeasonVirusAchievementRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.LWSeasonBossLoginDataManager:ParseRewardInfo(t)
  end
end

GetSeasonVirusAchievementRewardInfoMessage.HandleMessage = HandleMessage
return GetSeasonVirusAchievementRewardInfoMessage
