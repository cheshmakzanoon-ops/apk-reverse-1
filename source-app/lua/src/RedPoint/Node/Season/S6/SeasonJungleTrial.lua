local RedPoint = BaseClass("SeasonJungleTrial", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.OnJungleTrialRewardRefresh, self.Update)
  self:AddListener(EventId.OnJungleTrialBoxRefresh, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.JungleTrialDataManager:GetCanReceive() or DataCenter.JungleTrialDataManager:GetCanOpenBoxNum() > 0)
end

return RedPoint
