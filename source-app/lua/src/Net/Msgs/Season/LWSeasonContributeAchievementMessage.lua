local LWSeasonContributeAchievementMessage = BaseClass("LWSeasonContributeAchievementMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, rqType, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("rqType", tonumber(rqType))
  if id then
    self.sfsObj:PutInt("id", tonumber(id))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    return
  end
  local rqType = t.rqType
  if rqType == 1 then
    DataCenter.SeasonRewardDataManager:InitPersonalData(t, SeasonScoreRewardPanelType.PersonalContributeAchievement)
  elseif rqType == 2 then
    DataCenter.SeasonRewardDataManager:UpdatePersonalOccupyLandCount(t, SeasonScoreRewardPanelType.PersonalContributeAchievement)
  elseif rqType == 3 then
    DataCenter.SeasonRewardDataManager:GetSelectRewardSuccess(t, SeasonScoreRewardPanelType.PersonalContributeAchievement)
  end
end

LWSeasonContributeAchievementMessage.OnCreate = OnCreate
LWSeasonContributeAchievementMessage.HandleMessage = HandleMessage
return LWSeasonContributeAchievementMessage
