local RedPoint = BaseClass("SeasonFarmerBuildReward", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.Update)
  self:AddListener(EventId.CityAttachmentOneRewardFinish, self.Update)
  self:AddListener(EventId.CityAttachmentALLRewardFinish, self.Update)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  self:SetCount(DataCenter.SeasonFarmerManager:CountOfBuildReward())
end

return RedPoint
