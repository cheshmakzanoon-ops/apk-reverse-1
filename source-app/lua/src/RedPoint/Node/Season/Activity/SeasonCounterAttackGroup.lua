local RedPoint = BaseClass("SeasonCounterAttackGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self.isSimpleCount = true
  self:AddListener(EventId.OnCounterAttackActInfo, self.Update)
  self:AddListener(EventId.OnCounterAttackRoundAwardPoint, self.Update)
  self:AddListener(EventId.OnCounterAttackFirstSeen, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  local node = self:GetOrAddOnlyChild(RedDef.SeasonCounterAttackAward)
  node.isSimpleCount = true
  node:SetCount(DataCenter.CounterAttackDataManager:GetAwardRedPoint())
  node = self:GetOrAddOnlyChild(RedDef.SeasonCounterAttackFirst)
  node:SetCountBoolean(DataCenter.CounterAttackDataManager:GetFirstSeenRedPoint())
end

return RedPoint
