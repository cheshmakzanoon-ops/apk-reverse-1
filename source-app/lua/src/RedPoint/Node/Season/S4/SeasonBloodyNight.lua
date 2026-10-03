local RedPoint = BaseClass("SeasonBloodyNight", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OnBloodyNightTaskRedRefresh, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.BloodyNightDataManager:GetCanReceive() or DataCenter.BloodyNightDataManager:GetFirstSeenRedPoint())
end

return RedPoint
