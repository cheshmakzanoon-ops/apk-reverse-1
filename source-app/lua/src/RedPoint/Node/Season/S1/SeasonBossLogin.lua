local RedPoint = BaseClass("SeasonBossLogin", RedPointNode)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.SeasonVirusBossReddot, self.Update)
  self:AddListener(EventId.OnActBossRankRefresh, self.Update)
  self:AddListener(EventId.SeasonVirusBossReddot, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  self:SetCountBoolean(DataCenter.LWSeasonBossLoginDataManager:GetReddot())
end

return RedPoint
