local RedPoint = BaseClass("SeasonSeasonPreview", RedPointNode)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.GetSeasonPreviewTaskList, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.SeasonPreviewManager:GetActivityTaskRedState())
end

return RedPoint
