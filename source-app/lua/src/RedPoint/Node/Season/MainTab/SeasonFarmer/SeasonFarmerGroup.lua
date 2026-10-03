local RedPoint = BaseClass("SeasonFarmerGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.Al_Leave, self.Update)
  self:AddListener(EventId.Al_Join, self.Update)
  self:AddListener(EventId.OnEnterWorld, self.Update)
  self:AddListener(EventId.SeasonFarmerStateChange, self.Update)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  if not DataCenter.SeasonFarmerManager:IsOpen() or not DataCenter.SeasonFarmerManager:IsActive() then
    self:Reset()
    return
  end
  self:GetOrAddOnlyChild(RedDef.SeasonFarmerBuildReward)
  self:GetOrAddOnlyChild(RedDef.SeasonFarmerAchievement)
end

return RedPoint
