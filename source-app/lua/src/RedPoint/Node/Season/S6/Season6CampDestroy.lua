local RedPoint = BaseClass("Season6CampDestroy", RedPointGroup)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SeasonCampDestroyActRefresh, self.Update)
  self:AddListener(EventId.SeasonCampAchieveRewardRefresh, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update(activityId)
  local node = self:GetOrAddChild(RedDef.SeasonCampAchievementReward)
  node:SetCountBoolean(DataCenter.SeasonRewardDataManager:IsCampAchievementRewardTabFuckRed())
  node = self:GetOrAddChild(RedDef.Season6CampDestroyFirstFucked)
  node:SetCountBoolean(DataCenter.SeasonCampDestroyManager:GetFirstSeenRedPoint())
end

return RedPoint
