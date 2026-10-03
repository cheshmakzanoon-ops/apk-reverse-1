local RedPoint = BaseClass("SeasonGoldTree", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SeasonGoldTreeInfo, self.Update)
  self:AddListener(EventId.GoldTreeOpenCard, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCount(DataCenter.SeasonGoldTreeManager:CanPrayCardCount())
end

return RedPoint
