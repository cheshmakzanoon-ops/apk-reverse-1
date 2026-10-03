local RedPoint = BaseClass("SeasonMainTabGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
end

function RedPoint:__delete()
end

function RedPoint:SetData()
  if not SeasonUtil.IsInSeason() and not SeasonUtil.IsInSeasonPrepareMode() then
    self:RemoveAllChild()
    return
  end
  self:GetOrAddOnlyChild(RedDef.SeasonMainReward)
  self:GetOrAddOnlyChild(RedDef.SeasonTrendsReward)
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer and (infoPlayer:InSettleTime() or infoPlayer:InIdleTime()) then
    return
  end
  self:GetOrAddOnlyChild(RedDef.SeasonPersonalReward)
  self:GetOrAddOnlyChild(RedDef.SeasonMastery)
  self:GetOrAddOnlyChild(RedDef.SeasonFarmer)
end

return RedPoint
