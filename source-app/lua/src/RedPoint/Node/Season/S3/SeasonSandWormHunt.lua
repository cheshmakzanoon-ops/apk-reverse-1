local RedPoint = BaseClass("SeasonSandWormHunt", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OnSandWormHuntRewardRefresh, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.SandWormHuntDataManager:GetCanReceive() or DataCenter.SandWormHuntDataManager:GetFirstSeenRedPoint())
end

return RedPoint
