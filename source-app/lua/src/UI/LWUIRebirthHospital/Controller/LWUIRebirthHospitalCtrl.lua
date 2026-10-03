local LWUIRebirthHospitalCtrl = BaseClass("LWUIRebirthHospitalCtrl", UIBaseCtrl)

function LWUIRebirthHospitalCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIRebirthHospital)
end

function LWUIRebirthHospitalCtrl:GetDefaultSoldierCountList()
  local userResCountDic = {}
  local allDeadSoldier = DataCenter.RebirthHospitalManager:GetAllDeadSoldierList()
  local dic = {}
  local worldId = LuaEntry.Player:GetCurWorldId()
  for i = 1, #allDeadSoldier do
    local soldierTemplate = allDeadSoldier[i]:GetSoldierTemplate()
    if soldierTemplate ~= nil and (worldId == 0 and soldierTemplate.type == 1 or 0 < worldId and soldierTemplate.type == 3) then
      local singleCost = allDeadSoldier[i]:GetSoldierRebirthResourceCost(1)
      if table.IsNullOrEmpty(singleCost) then
        dic[soldierTemplate.id] = allDeadSoldier[i]:GetDeadCount()
      else
        local countDic = {}
        for resType, needCount in pairs(singleCost) do
          local userCount = 0
          if userResCountDic[resType] == nil then
            userCount = LuaEntry.Resource:GetCntByResType(resType)
            userResCountDic[resType] = userCount
          else
            userCount = userResCountDic[resType]
          end
          if needCount <= 0 then
            countDic[resType] = allDeadSoldier[i]:GetDeadCount()
          else
            countDic[resType] = math.min(math.floor(userCount / needCount), allDeadSoldier[i]:GetDeadCount())
            if userResCountDic[resType] == nil then
            end
          end
        end
        local min = Mathf.Infinity
        for _, count in pairs(countDic) do
          if count < min then
            min = count
          end
        end
        for resType, needCount in pairs(singleCost) do
          local costCount = needCount * min
          if userResCountDic[resType] ~= nil then
            userResCountDic[resType] = userResCountDic[resType] - costCount
          end
        end
        dic[soldierTemplate.id] = min
      end
    end
  end
  return dic
end

function LWUIRebirthHospitalCtrl:GetResourceCostDict(soldierList)
  local resourceDic = {}
  for _, v in pairs(soldierList) do
    if v.curCount ~= nil then
      local cost = v:GetSoldierRebirthResourceCost(v.curCount)
      for resType, resCount in pairs(cost) do
        if resourceDic[resType] == nil then
          resourceDic[resType] = resCount
        else
          resourceDic[resType] = resourceDic[resType] + resCount
        end
      end
    end
  end
  return resourceDic
end

function LWUIRebirthHospitalCtrl:GetRebirthMessageParam(soldierList)
  local res = {}
  for i, v in pairs(soldierList) do
    if v.curCount ~= nil and v.curCount > 0 then
      table.insert(res, {
        armyId = tostring(v.armyId),
        rebirthNum = v.curCount
      })
    end
  end
  return res
end

function LWUIRebirthHospitalCtrl:OpenHistory()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRebirthHospitalHistory)
end

return LWUIRebirthHospitalCtrl
