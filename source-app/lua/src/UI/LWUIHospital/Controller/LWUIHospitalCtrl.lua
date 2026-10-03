local LWUIHospitalCtrl = BaseClass("LWUIHospitalCtrl", UIBaseCtrl)
local math_min = math.min
local math_floor = math.floor
local tonumber = _ENV.tonumber
local DataCenter = _ENV.DataCenter
local HospitalManager = DataCenter.HospitalManager
local ResourceType = _ENV.ResourceType

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIHospital)
end

local function GetSoldier()
  return HospitalManager:GetDeadHospital()
end

local function GetHospitalQueue(self)
  return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
end

local function GetStartSoldierCountDic()
  local hasMetal = LuaEntry.Resource:GetCntByResType(ResourceType.Metal)
  local hasFood = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  local soldiers = GetSoldier()
  local dic = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  local localTime = HospitalManager:GetSoldierCureValueLocal()
  local resCureCount, timeCureCount, remain = 0, 0, localTime
  local newRemain = remain
  for i = 1, #soldiers do
    local id = tonumber(soldiers[i].armyId)
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(id)
    if worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3 then
      local cureCostMetal = soldierTemplate.cureCost[ResourceType.Metal] or 0
      local cureCostFood = soldierTemplate.cureCost[ResourceType.Food] or 0
      local count = 1
      if cureCostMetal == 0 and cureCostFood == 0 then
        resCureCount = soldiers[i].dead
      else
        local metalcount = 0
        local hasFoodcount = 0
        if cureCostMetal ~= nil and cureCostMetal ~= 0 then
          metalcount = math_min(math_floor(hasMetal / cureCostMetal), soldiers[i].dead)
        else
          metalcount = soldiers[i].dead
        end
        if cureCostFood ~= nil and cureCostFood ~= 0 then
          hasFoodcount = math_min(math_floor(hasFood / cureCostFood), soldiers[i].dead)
        else
          hasFoodcount = soldiers[i].dead
        end
        resCureCount = math_min(metalcount, hasFoodcount) or 0
      end
      if 0 < localTime then
        timeCureCount, newRemain = HospitalManager:CalculateCureTime2Count(remain, soldierTemplate.cureTime)
        if timeCureCount >= resCureCount then
          count = resCureCount
          remain = remain - HospitalManager:CalculateCount2CureTime(resCureCount, soldierTemplate.cureTime)
        else
          count = timeCureCount
          remain = newRemain
        end
      else
        count = resCureCount
      end
      count = 0 < count and count or 1
      hasMetal = hasMetal - count * cureCostMetal
      hasFood = hasFood - count * cureCostFood
      dic[id] = count
    end
  end
  return dic
end

local function GetHospitalMaxVolume()
  return math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_MAX_STOCK))
end

local function GetMaxDeadSoldier()
  local soldiers = HospitalManager:GetDeadHospital()
  local maxNumber = 0
  for i = 1, #soldiers do
    if soldiers[i].dead then
      maxNumber = maxNumber + soldiers[i].dead
    end
  end
  return maxNumber
end

local function GetSoldiersIsSpill(soldierList)
  local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
  local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
  local maxCount = number - playerNumber
  local curCount = 0
  for i, info in pairs(soldierList) do
    if info.curCount ~= nil and 0 < info.curCount then
      curCount = curCount + info.curCount
    end
  end
  return maxCount >= curCount
end

function LWUIHospitalCtrl:IsDeadSoldierEnough(soldierList)
  local isEnough = true
  local totalSoldierList = DataCenter.HospitalManager:GetDeadHospital()
  if not table.IsNullOrEmpty(soldierList) then
    for i, info in pairs(soldierList) do
      local armyId = tonumber(info.armyId)
      local count = tonumber(info.curCount)
      local totalCount = 0
      for j, totalInfo in pairs(totalSoldierList) do
        if tonumber(totalInfo.armyId) == armyId then
          totalCount = tonumber(totalInfo.dead)
          break
        end
      end
      if count > totalCount then
        isEnough = false
        break
      end
    end
  end
  return isEnough
end

function LWUIHospitalCtrl:CheckCompleteImmediateResourceIsEnough(expenditureDic, callbackData)
  if not table.IsNullOrEmpty(expenditureDic) then
    local needGoldCount = 0
    for resType, resData in pairs(expenditureDic) do
      local totalNeedCount = self:GetHealCostResourceCount(resData.exp)
      local alreadyOwnCount = CommonUtil.GetResOrItemCount(resType)
      local useItemSupportCount = 0
      if callbackData.goodsUseDatas ~= nil then
        for _, useData in pairs(callbackData.goodsUseDatas) do
          if useData.resType == resType then
            local goItemList = LWResourceLackUtil:GetResourceByUseItemWay(resType)
            if not table.IsNullOrEmpty(useData.usedItems) and not table.IsNullOrEmpty(goItemList) then
              for _, useItem in pairs(useData.usedItems) do
                for _, goItem in pairs(goItemList) do
                  if useItem.itemId == goItem.itemId then
                    useItemSupportCount = useItemSupportCount + useItem.count * goItem.give
                    break
                  end
                end
              end
            end
          end
        end
      end
      local stillNeedCount = totalNeedCount - alreadyOwnCount - useItemSupportCount
      if 0 < stillNeedCount then
        local needGold = CommonUtil.GetResGoldByType(resType, stillNeedCount)
        if 0 < needGold then
          needGoldCount = needGoldCount + needGold
        end
      end
    end
    if 0 < needGoldCount and needGoldCount > callbackData.resGold then
      return false
    end
  end
  return true
end

function LWUIHospitalCtrl:CheckDiamondConfirmResourceIsEnough(expenditureDic, resGold)
  if not table.IsNullOrEmpty(expenditureDic) then
    local goldCountTotal = 0
    for resType, resData in pairs(expenditureDic) do
      local totalNeedCount = self:GetHealCostResourceCount(resData.exp)
      local curCount = LuaEntry.Resource:GetCntByResType(resType)
      local needCount = totalNeedCount - curCount
      if 0 < needCount then
        local goldCount = CommonUtil.GetResGoldByType(resType, totalNeedCount - curCount)
        if 0 < goldCount then
          goldCountTotal = goldCountTotal + goldCount
        end
      end
    end
    return resGold >= goldCountTotal
  end
  return true
end

function LWUIHospitalCtrl:GetHealCostResourceCount(originalCount)
  local healGoldEffectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_HEALGOLD_REDUCE)
  healGoldEffectValue = healGoldEffectValue or 0
  return math.ceil(originalCount * (1 - healGoldEffectValue))
end

LWUIHospitalCtrl.CloseSelf = CloseSelf
LWUIHospitalCtrl.GetSoldier = GetSoldier
LWUIHospitalCtrl.GetHospitalQueue = GetHospitalQueue
LWUIHospitalCtrl.GetHospitalMaxVolume = GetHospitalMaxVolume
LWUIHospitalCtrl.GetMaxDeadSoldier = GetMaxDeadSoldier
LWUIHospitalCtrl.GetStartSoldierCountDic = GetStartSoldierCountDic
LWUIHospitalCtrl.GetSoldiersIsSpill = GetSoldiersIsSpill
return LWUIHospitalCtrl
