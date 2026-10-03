local SeasonBountyShopRed = BaseClass("SeasonBountyShopRed", RedPointNode)

function SeasonBountyShopRed:__init(nodeName)
  self:AddListener(EventId.SeasonBountyShopGetListUpdate, self.UpdateRed)
  self:AddListener(EventId.SeasonBountyShopDailyRedUpdate, self.UpdateRed)
  self:AddListener(EventId.SeasonBountyShopExchangeUpdate, self.UpdateRed)
  self:AddListener(EventId.SeasonMilitaryLevelUpUpdate, self.UpdateRed)
end

function SeasonBountyShopRed:SetData(activityId)
  self:UpdateRed()
end

function SeasonBountyShopRed:UpdateRed()
  local isShow = DataCenter.SeasonBountyShopManager:ShowDailyRed()
  self:SetCountBoolean(isShow)
end

return SeasonBountyShopRed
