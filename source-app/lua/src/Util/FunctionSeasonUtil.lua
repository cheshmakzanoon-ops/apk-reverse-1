local FunctionSeasonUtil = {}
FunctionSeasonUtil.FuncType = {
  PersonalArmsExchange = 101,
  DispatchTaskMark = 102,
  ShopAutoMax = 104,
  TrunkQuickAttack = 105,
  RadarQuickFinish = 106
}

function FunctionSeasonUtil.IsFuncOpen(funcType)
  local cell = LocalController:instance():tryGetLine(TableName.LW_FUNCTION_SEASON, funcType)
  if cell == nil then
    return false
  end
  local type = checknumber(cell.type)
  if type == 1 then
    return FunctionSeasonUtil.HandleSelfServer(cell)
  end
  return false
end

function FunctionSeasonUtil.HandleSelfServer(cell)
  local seasonInfoTemplate = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  return FunctionSeasonUtil.CheckSeasonDay(seasonInfoTemplate, cell)
end

function FunctionSeasonUtil.CheckSeasonDay(seasonInfoTemplate, cell)
  if cell == nil then
    return false
  end
  local configSeason = checknumber(cell.season)
  local configSeasonType = checknumber(cell.season_type)
  local configSeasonDay = checknumber(cell.season_day)
  local season, seasonDay = 0, 0
  if seasonInfoTemplate ~= nil then
    season = checknumber(seasonInfoTemplate:GetSeasonId(true))
  end
  seasonDay = UITimeManager:GetInstance():GetOpenServerDay()
  if configSeason > season then
    return false
  end
  if configSeason < season then
    return true
  end
  if season == configSeason then
    if configSeasonType == 1 then
      if 0 < season then
        if seasonInfoTemplate:InPreviewMode() then
          return false
        end
        seasonDay = seasonInfoTemplate:GetSeasonDurationDay() + 1
      end
      return configSeasonDay <= seasonDay
    elseif configSeasonType == 2 then
      if 0 < season then
        if not seasonInfoTemplate:InPreviewMode() then
          return true
        end
        local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(seasonInfoTemplate.nextSeasonPreviewTime // 1000) * 1000
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local duration = math.max(curTime - zeroTime, 0)
        seasonDay = Mathf.Floor(duration // (1000 * OneDayTime)) + 1
      end
      return configSeasonDay <= seasonDay
    end
  end
  return false
end

function FunctionSeasonUtil.CheckSeasonDayTest(seasonInfoTemplate, cell)
  if cell == nil then
    return false
  end
  local season, seasonDay = 0, 0
  if seasonInfoTemplate ~= nil then
    season = checknumber(seasonInfoTemplate:GetSeasonId(true))
    if season == 0 then
      seasonDay = UITimeManager:GetInstance():GetOpenServerDay()
    end
  end
  if season < cell.season then
    return false
  end
  if season > cell.season then
    return true
  end
  if season == cell.season then
    if cell.season_type == 1 then
      if seasonInfoTemplate ~= nil then
        if seasonInfoTemplate:InPreviewMode() then
          return false
        end
        seasonDay = seasonInfoTemplate:GetSeasonDurationDay() + 1
      end
      return seasonDay >= cell.season_day
    elseif cell.season_type == 2 then
      if seasonInfoTemplate ~= nil then
        if not seasonInfoTemplate:InPreviewMode() then
          return true
        end
        local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(seasonInfoTemplate.nextSeasonPreviewTime // 1000) * 1000
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local duration = math.max(curTime - zeroTime, 0)
        seasonDay = Mathf.Floor(duration // (1000 * OneDayTime)) + 1
      end
      return seasonDay >= cell.season_day
    end
  end
  return false
end

return ConstClass("FunctionSeasonUtil", FunctionSeasonUtil)
