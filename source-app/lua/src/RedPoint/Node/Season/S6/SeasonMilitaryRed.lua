local SeasonMilitaryRed = BaseClass("SeasonMilitaryRed", RedPointNode)

function SeasonMilitaryRed:__init(nodeName)
  self:AddListener(EventId.SeasonMilitaryInfoUpdate, self.UpdateRed)
  self:AddListener(EventId.SeasonMilitaryLevelUpUpdate, self.UpdateRed)
  self:AddListener(EventId.SeasonMilitaryClaimDaily, self.UpdateRed)
end

function SeasonMilitaryRed:SetData(activityId)
  self:UpdateRed()
end

function SeasonMilitaryRed:UpdateRed()
  local count = DataCenter.SeasonMilitaryManager:ShowRedCount()
  self:SetCount(count)
end

return SeasonMilitaryRed
