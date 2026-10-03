local RedPoint = BaseClass("SeasonActivityTetris", RedPointNode)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(DataCenter.SeasonTetrisManager:GetLeftCount())
end

return RedPoint
