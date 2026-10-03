local RedPoint = BaseClass("SeasonDiggingGame", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.DiggingGameRedUpdate, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(DataCenter.DiggingDataManager:GetRedCount())
end

return RedPoint
