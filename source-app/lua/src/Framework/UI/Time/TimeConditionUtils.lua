local TimeConditionUtils = {}

function TimeConditionUtils.CheckTimeConditionsByStr(conditionStr)
  if string.IsNullOrEmpty(conditionStr) then
    return true
  end
  local result = true
  local conditionStrSplit = string.split(conditionStr, "|")
  for i, v in ipairs(conditionStrSplit) do
    if not TimeConditionUtils.CheckSingleTimeConditionByStr(v) then
      result = false
      break
    end
  end
  return result
end

function TimeConditionUtils.CheckSingleTimeConditionByStr(conditionStr)
  if conditionStr == "212" then
    return DataCenter.SeasonAllyFriendManager:HasFriend()
  end
  if string.IsNullOrEmpty(conditionStr) then
    return true
  end
  local conditionStrSplit = string.split(conditionStr, ";")
  if #conditionStrSplit == 2 then
    return TimeConditionUtils.CheckSingleTimeCondition(conditionStrSplit[1], conditionStrSplit[2])
  end
  return false
end

function TimeConditionUtils.CheckSingleTimeCondition(conditionType, conditionParam)
  if string.IsNullOrEmpty(conditionType) or string.IsNullOrEmpty(conditionParam) then
    return false
  end
  local conditionTypeNum = tonumber(conditionType)
  if conditionTypeNum == TimeConditionType.Type_8 then
    local curOpenServerDay = UITimeManager:GetInstance():GetServerOpenDays()
    local startOpenServerDay = tonumber(conditionParam)
    return curOpenServerDay >= startOpenServerDay
  elseif conditionTypeNum == TimeConditionType.Type_9 then
    local curOpenServerDay = UITimeManager:GetInstance():GetServerOpenDays()
    local startOpenServerDay = tonumber(conditionParam)
    return curOpenServerDay <= startOpenServerDay
  elseif conditionTypeNum == TimeConditionType.Type_144 then
    local conditionParamSplit = string.split(conditionParam, "-")
    if #conditionParamSplit == 2 then
      local curSeason = SeasonUtil.GetSeason()
      local startSeason = tonumber(conditionParamSplit[1])
      local endSeason = tonumber(conditionParamSplit[2])
      return curSeason >= startSeason and curSeason <= endSeason
    end
  elseif conditionTypeNum == TimeConditionType.Type_148 then
    local conditionParamSplit = string.split(conditionParam, "-")
    if #conditionParamSplit == 2 then
      local seasonDay = SeasonUtil.GetSeasonDay()
      local startSeasonDay = tonumber(conditionParamSplit[1])
      local endSeasonDay = tonumber(conditionParamSplit[2])
      return seasonDay >= startSeasonDay and seasonDay <= endSeasonDay
    end
  elseif conditionTypeNum == TimeConditionType.Type_149 then
    local conditionParamSplit = string.split(conditionParam, ",")
    if #conditionParamSplit == 2 then
      local startSeason = tonumber(conditionParamSplit[1])
      local startSeasonDay = tonumber(conditionParamSplit[2])
      local curSeason = SeasonUtil.GetSeason()
      if startSeason < curSeason then
        return true
      end
      if startSeason > curSeason then
        return false
      end
      local seasonDay = SeasonUtil.GetSeasonDay()
      return startSeasonDay <= seasonDay
    end
  elseif conditionTypeNum == TimeConditionType.Type_150 then
    local conditionParamSplit = string.split(conditionParam, ",")
    if #conditionParamSplit == 2 then
      local endSeason = tonumber(conditionParamSplit[1])
      local endSeasonDay = tonumber(conditionParamSplit[2])
      local curSeason = SeasonUtil.GetSeason()
      if endSeason > curSeason then
        return true
      end
      if endSeason < curSeason then
        return false
      end
      local seasonDay = SeasonUtil.GetSeasonDay()
      return endSeasonDay >= seasonDay
    end
  elseif conditionTypeNum == TimeConditionType.Type_1 then
    local mainLv = DataCenter.BuildManager.MainLv
    local needLv = tonumber(conditionParam)
    if mainLv and mainLv >= needLv then
      return true
    end
  elseif conditionTypeNum == TimeConditionType.Type_212 then
    return DataCenter.SeasonAllyFriendManager:HasFriend()
  end
  return false
end

return ConstClass("TimeConditionUtils", TimeConditionUtils)
