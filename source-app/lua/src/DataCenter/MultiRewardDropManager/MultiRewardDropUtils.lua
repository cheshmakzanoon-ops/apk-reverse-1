local MultiRewardDropUtils = {}

local function GetCurCanEnjoyMaxMultiValue(rewardType)
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  return DataCenter.MultiRewardDropManager:GetCanEnjoyMaxMultiValue(rewardType, curTime)
end

local function GetTruckCurCanEnjoyMaxMultiValue()
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  return MultiRewardDropUtils.GetTruckTargetTimeCanEnjoyMaxMultiValue(curTime)
end

local function GetTruckTargetTimeCanEnjoyMaxMultiValue(truckDepartureTime)
  if not truckDepartureTime then
    return 1
  end
  return DataCenter.MultiRewardDropManager:GetCanEnjoyMaxMultiValue(MultiRewardType.TrainReward, truckDepartureTime)
end

local function GetCurPersonalArmsCanEnjoyMaxMultiValue()
  return GetCurCanEnjoyMaxMultiValue(MultiRewardType.PersonalArms)
end

local function GetCurRadarTreasureReceiveMultiValue(time)
  if not time then
    return 1
  end
  return DataCenter.MultiRewardDropManager:GetCanEnjoyMaxMultiValue(MultiRewardType.DetectTreasure, time)
end

MultiRewardDropUtils.GetCurCanEnjoyMaxMultiValue = GetCurCanEnjoyMaxMultiValue
MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue = GetTruckCurCanEnjoyMaxMultiValue
MultiRewardDropUtils.GetTruckTargetTimeCanEnjoyMaxMultiValue = GetTruckTargetTimeCanEnjoyMaxMultiValue
MultiRewardDropUtils.GetCurPersonalArmsCanEnjoyMaxMultiValue = GetCurPersonalArmsCanEnjoyMaxMultiValue
MultiRewardDropUtils.GetCurRadarTreasureReceiveMultiValue = GetCurRadarTreasureReceiveMultiValue
return ConstClass("MultiRewardDropUtils", MultiRewardDropUtils)
