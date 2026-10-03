local RedPoint = BaseClass("SeasonGreen", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SeasonGreenCityProgressInfo, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(DataCenter.SeasonGreenManager:GetRedCount())
end

return RedPoint
