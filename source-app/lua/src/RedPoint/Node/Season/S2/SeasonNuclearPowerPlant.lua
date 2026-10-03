local RedPoint = BaseClass("SeasonNuclearPowerPlant", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.ActNuclearTaskRedStateChange, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskRedState())
end

return RedPoint
