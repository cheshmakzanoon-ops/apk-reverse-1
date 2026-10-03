local ActExchangeHeroDataManager = BaseClass("ActExchangeHeroDataManager")

local function __init(self)
  self.activityReceiveDic = {}
end

local function __delete(self)
  self.activityReceiveDic = nil
end

function ActExchangeHeroDataManager:UpdateData(data)
  local activityId = toInt(data.id)
  self.activityReceiveDic[activityId] = data.receiveReward
end

function ActExchangeHeroDataManager:GetReceiveRewardState(activityId)
  local activityIdVal = toInt(activityId)
  if not table.containsKey(self.activityReceiveDic, activityIdVal) then
    return false
  end
  return self.activityReceiveDic[activityIdVal]
end

ActExchangeHeroDataManager.__init = __init
ActExchangeHeroDataManager.__delete = __delete
return ActExchangeHeroDataManager
