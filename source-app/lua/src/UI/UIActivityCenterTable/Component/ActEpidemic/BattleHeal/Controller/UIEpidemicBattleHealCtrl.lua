local UIEpidemicBattleHealCtrl = BaseClass("UIEpidemicBattleHealCtrl", UIBaseCtrl)
local HospitalManager = DataCenter.HospitalManager

function UIEpidemicBattleHealCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleHeal)
end

function UIEpidemicBattleHealCtrl:GetStartSoldierCountDic()
  local hasMetal = LuaEntry.Resource:GetCntByResType(ResourceType.Metal)
  local hasFood = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  local soldiers = HospitalManager:GetDeadHospital()
  local dic = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  local localTime = HospitalManager:GetSoldierCureValueLocal()
  local resCureCount, timeCureCount, remain = 0, 0, localTime
  local newRemain = remain
  for i = 1, #soldiers do
    local id = tonumber(soldiers[i].armyId)
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(id)
    if 0 < worldId and soldierTemplate.type == 3 then
      resCureCount = soldiers[i].dead
      local count = 1
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
      dic[id] = count
    end
  end
  return dic
end

function UIEpidemicBattleHealCtrl:GetMaxDeadSoldier()
  local soldiers = HospitalManager:GetDeadHospital()
  local maxNumber = 0
  for i = 1, #soldiers do
    if soldiers[i].dead then
      maxNumber = maxNumber + soldiers[i].dead
    end
  end
  return maxNumber
end

return UIEpidemicBattleHealCtrl
