local RaceEntranceUtil = {}
local SIGN_OPEN_KEY = "_RACE_ENTRANCE_OPEN_"
local SIGN_UNLOCK_KEY = "_RACE_ENTRANCE_UNLOCK_"
RaceEntranceUtil.OpenSate = {
  Lock = 0,
  UnLock = 1,
  Coming = 2,
  Open = 3
}

function RaceEntranceUtil.CleanTemplate()
  RaceEntranceUtil.__templates = nil
  RaceEntranceUtil.__isNewOpen = nil
  RaceEntranceUtil.__isOldOpen = nil
  RaceEntranceUtil.__isNewMigration = nil
  RaceEntranceUtil.__templateWarZoneGroup = nil
  RaceEntranceUtil.__timeInfos = nil
  RaceEntranceUtil.__lastSyncTime = 0
end

function RaceEntranceUtil.IsNewEntranceOpen()
  RaceEntranceUtil.__isNewOpen = LuaEntry.DataConfig:CheckSwitch("new_activity_test2")
  return RaceEntranceUtil.__isNewOpen
end

function RaceEntranceUtil.IsNewMigration()
  RaceEntranceUtil.__isNewMigration = LuaEntry.DataConfig:CheckSwitch("new_activity_test2_migration")
  return RaceEntranceUtil.__isNewMigration
end

function RaceEntranceUtil.IsOldEntranceOpen()
  RaceEntranceUtil.__isOldOpen = LuaEntry.DataConfig:CheckSwitch("new_activity_test2_battle_old")
  return RaceEntranceUtil.__isOldOpen
end

function RaceEntranceUtil.ReqTimeInfo()
  local lastSyncTime = RaceEntranceUtil.__lastSyncTime or 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if 3 <= curTime - lastSyncTime then
    SFSNetwork.SendMessage(MsgDefines.BattleFieldEntranceInfo)
    RaceEntranceUtil.__lastSyncTime = curTime
  end
end

function RaceEntranceUtil.HandleTimeInfo(msg)
  local dic = {}
  for i, v in ipairs(msg.data or {}) do
    dic[v.type] = v.time
  end
  RaceEntranceUtil.__timeInfos = dic
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntranceTime)
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
end

function RaceEntranceUtil.GetTemplates()
  if RaceEntranceUtil.__templates == nil then
    local templates = {}
    local mySplit = string.split
    local mySplit2I = string.string2array_i_oneSep
    LocalController:instance():visitTable(TableName.BattleField_Entrance, function(id, lineData)
      local data = {}
      data.id = id
      local unLockTime = mySplit(lineData:getValue("unlock_time"), ",")
      data.season = toInt(unLockTime[1])
      data.week = toInt(unLockTime[2])
      data.icons = mySplit(lineData:getValue("icons"), ",")
      data.icons_desc = mySplit(lineData:getValue("icons_desc"), ",")
      data.desc = lineData:getValue("desc")
      data.oping_soon_desc = lineData:getValue("oping_soon_desc")
      data.cross_week_activity = lineData:getIntValue("Cross_week_activity")
      data.bg = lineData:getValue("bg")
      data.activity_id = lineData:getValue("activity_id")
      data.type = toInt(GetTableData(TableName.Activity, data.activity_id, "type"))
      local openTime = mySplit(lineData:getValue("open_time"), "|")
      local open_time = {}
      for _, v in pairs(openTime) do
        local times = mySplit2I(v, ",")
        open_time[tostring(times[1])] = times
      end
      data.open_time = open_time
      data.bubble_icon = lineData:getValue("bubble_icon")
      local rewardInfos = mySplit(lineData:getValue("reward_icon"), "|")
      data.rewards = {}
      for _, v in pairs(rewardInfos) do
        local infos = mySplit(v, ";")
        table.insert(data.rewards, infos)
      end
      templates[data.type] = data
    end)
    RaceEntranceUtil.__templates = templates
  end
  for _, v in pairs(RaceEntranceUtil.__templates) do
    v.state, v.comingTime = RaceEntranceUtil.GetState(v)
  end
  return RaceEntranceUtil.__templates
end

function RaceEntranceUtil.GetOneTemplate(actType)
  local needUpdate = true
  if RaceEntranceUtil.__templates == nil then
    RaceEntranceUtil.GetTemplates()
    needUpdate = false
  end
  local v = RaceEntranceUtil.__templates[actType]
  if v and needUpdate then
    v.state, v.comingTime = RaceEntranceUtil.GetState(v)
  end
  return v
end

function RaceEntranceUtil._GetNextOpenTime(timeMs, weekDay, bUnlockWeek)
  local uiTimeMgr = UITimeManager:GetInstance()
  local curWeekDay = uiTimeMgr:GetWeekdayIndex(timeMs)
  local timeSec = 0
  local inWeek = false
  if bUnlockWeek then
    inWeek = weekDay > curWeekDay
  else
    inWeek = weekDay >= curWeekDay
  end
  if inWeek then
    local curSeconds = uiTimeMgr:GetServerSeconds()
    local dayOffset = weekDay - curWeekDay
    local targetDay = curSeconds + dayOffset * OneDayTime
    timeSec = uiTimeMgr:GetTodayZeroServerTime(targetDay)
  else
    timeSec = uiTimeMgr:GetNextWeekDay(weekDay)
    timeSec = timeSec / 1000
  end
  return timeSec
end

function RaceEntranceUtil.TransformTime(timeStr, pattern, extInfo)
  local timeStamp = 0
  if not string.IsNullOrEmpty(timeStr) then
    xpcall(function()
      local year, month, day, hour, min, sec = string.gmatch(timeStr, pattern)()
      hour = tonumber(hour) or 0
      min = tonumber(min) or 0
      sec = tonumber(sec) or 0
      if tonumber(year) ~= nil and tonumber(month) ~= nil and tonumber(day) ~= nil then
        timeStamp = SafeLocalOsTime({
          day = day,
          month = month,
          year = year,
          hour = hour,
          min = min,
          sec = sec
        })
        timeStamp = math.floor(UITimeManager:GetInstance():GetLocalTimeToServerTimestamp(timeStamp))
      end
    end, function()
      timeStamp = 0
      Logger.LogError(string.format("[RaceEntranceUtil] transformTime error by fix 1 hour: timeStr=%s, localTime=%s, extInfo=%s", timeStr, SafeLocalOsTime(), extInfo))
    end)
  end
  return timeStamp
end

function RaceEntranceUtil._InitWarZoneTime()
  local warZoneGroup = {}
  local myInsert = table.insert
  local sToAs = string.string2array_s
  local hasV = table.hasvalue
  local myServerId = tostring(LuaEntry.Player:GetSourceServerId())
  local KEY_PATTERN = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  LocalController:instance():visitTable(TableName.LWZoneWar, function(id, lineData)
    local have = false
    local tb = sToAs(lineData:getValue("server_ids"), "|", ";")
    for _, v in ipairs(tb) do
      if hasV(v, myServerId) then
        have = true
        break
      end
    end
    if not have then
      return
    end
    local extInfo = string.format("%s-%s", TableName.LWZoneWar, id)
    local timeStr = lineData:getValue("open_time")
    local openTimeStamp = RaceEntranceUtil.TransformTime(timeStr, KEY_PATTERN, extInfo)
    if openTimeStamp == 0 then
      return
    end
    timeStr = lineData:getValue("end_time")
    local endTimeStamp = RaceEntranceUtil.TransformTime(timeStr, KEY_PATTERN, extInfo)
    if endTimeStamp == 0 then
      return
    end
    myInsert(warZoneGroup, {openTime = openTimeStamp, endTime = endTimeStamp})
  end)
  RaceEntranceUtil.__templateWarZoneGroup = warZoneGroup
end

function RaceEntranceUtil._GetCurTemplateWarZoneTime(checkSeconds)
  if RaceEntranceUtil.__templateWarZoneGroup == nil then
    RaceEntranceUtil._InitWarZoneTime()
  end
  for _, v in ipairs(RaceEntranceUtil.__templateWarZoneGroup) do
    if checkSeconds >= v.openTime and checkSeconds <= v.endTime then
      return v.endTime
    end
  end
  return 0
end

function RaceEntranceUtil.CheckMeteoriteResourceByServerId(serverId)
  if CS.UnityEngine.Application.isEditor or serverId == LuaEntry.Player:GetSelfServerId() then
    return true
  end
  local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(serverId)
  if config == nil then
    return true
  end
  local seasonId = toInt(config.server_index)
  local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local sTime, eTime = DataCenter.ActMeteoriteBattleManager:GetCurTemplateServerGroupOpenTime(seasonId, serverId)
  local realOpenSec = sTime or 0
  local realCloseSec = eTime or 0
  if curSeconds >= realOpenSec and curSeconds <= realCloseSec then
    local flag = RaceEntranceUtil.IsNeedShowLoadingByType(EnumActivity.ActMeteorite.Type, true, true)
    return not flag
  end
  return true
end

function RaceEntranceUtil._CheckMeteoriteState(template, season)
  local curSeason = season or SeasonUtil.GetSeason()
  if curSeason == 0 then
    local weekSec = OneWeekTime
    local open_time = template.open_time
    local seasonInfo = open_time["1"]
    if seasonInfo == nil then
      return true, RaceEntranceUtil.OpenSate.Lock, 0
    end
    local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
    local sTime = DataCenter.ActMeteoriteBattleManager:GetCurTemplateServerGroupOpenTime(curSeason)
    local realOpenSec = sTime or 0
    local weekDay = seasonInfo[4] or 0
    local weekIdx = UITimeManager:GetInstance():GetWeekdayIndex(realOpenSec * 1000)
    if weekDay ~= weekIdx then
      realOpenSec = realOpenSec + OneDayTime * (weekDay - weekIdx)
    end
    if 0 < realOpenSec and curSeconds < realOpenSec then
      local preTime = realOpenSec - weekSec
      if curSeconds < preTime then
        return true, RaceEntranceUtil.OpenSate.Lock, 0
      else
        return true, RaceEntranceUtil.OpenSate.Coming, realOpenSec
      end
    end
    return true, RaceEntranceUtil.OpenSate.UnLock, 0
  end
  return false
end

function RaceEntranceUtil._GetStateInUnLock(weekDay, template, bUnlockWeek)
  local state = RaceEntranceUtil.OpenSate.UnLock
  local time = 0
  if weekDay ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local realOpenSec = RaceEntranceUtil._GetNextOpenTime(curTime, weekDay, bUnlockWeek)
    if template.type == EnumActivity.ActDragon.Type then
      local para4 = LocalController:instance():getIntValue(TableName.Activity, template.activity_id, "para4", 15)
      realOpenSec = realOpenSec + para4 * 60
    end
    local weekSec = OneWeekTime
    if template.cross_week_activity == 1 then
      local nextSeasonStartTime = DataCenter.SeasonDataManager:GetNextSeasonStartTime()
      if 0 < nextSeasonStartTime and nextSeasonStartTime <= (realOpenSec + weekSec) * 1000 then
        return state, time
      end
    end
    local preSec = realOpenSec - weekSec
    if curTime >= preSec * 1000 then
      state = RaceEntranceUtil.OpenSate.Coming
      time = realOpenSec
    end
  end
  return state, time
end

function RaceEntranceUtil.GetState(template)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(template.activity_id)
  if actInfo and actInfo:IsValid() then
    return RaceEntranceUtil.OpenSate.Open, 0
  end
  local state = RaceEntranceUtil.OpenSate.Lock
  local time = 0
  local nowSeason, seasonWeek = SeasonUtil.GetSeasonWeek()
  nowSeason = nowSeason or 0
  seasonWeek = seasonWeek or 0
  if nowSeason > template.season or nowSeason == template.season and seasonWeek >= template.week then
    local timeInfos = RaceEntranceUtil.__timeInfos or {}
    local nextOpenTime = timeInfos[template.type]
    if nextOpenTime ~= nil then
      state = RaceEntranceUtil.OpenSate.UnLock
      local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
      if 0 < nextOpenTime and nextOpenTime - curSeconds < OneWeekTime then
        state = RaceEntranceUtil.OpenSate.Coming
        time = nextOpenTime
      end
      return state, time
    end
    if template.type == EnumActivity.ActMeteorite.Type then
      local f, s, t = RaceEntranceUtil._CheckMeteoriteState(template)
      if f then
        return s, t
      end
    end
    state = RaceEntranceUtil.OpenSate.UnLock
    local bUnlockWeek = nowSeason == template.season and seasonWeek == template.week
    local open_time = template.open_time
    local normalInfo = open_time["0"]
    if normalInfo ~= nil then
      return RaceEntranceUtil._GetStateInUnLock(normalInfo[2], template, bUnlockWeek)
    end
    local seasonInfo = open_time["1"]
    if seasonInfo ~= nil then
      local checkSeason = seasonInfo[2] or 0
      local checkWeek = seasonInfo[3] or 0
      if nowSeason < checkSeason or seasonWeek < checkWeek then
        return state, time
      end
      state, time = RaceEntranceUtil._GetStateInUnLock(seasonInfo[4] or 0, template, bUnlockWeek)
      if template.type == EnumActivity.ActMeteorite.Type and state == RaceEntranceUtil.OpenSate.Coming then
        local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
        local endTime = RaceEntranceUtil._GetCurTemplateWarZoneTime(curSeconds)
        if endTime ~= 0 and time <= endTime then
          state = RaceEntranceUtil.OpenSate.UnLock
          time = 0
        end
      end
    end
  end
  return state, time
end

function RaceEntranceUtil.ReqActInfo(actType)
  if actType ~= nil then
    local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(actType)
    if activityData == nil then
      return
    end
  end
  if actType == EnumActivity.ActDragon.Type then
    DataCenter.ActDragonManager:ReqActInfo()
  end
  if actType == EnumActivity.ActWinterStorm.Type then
    DataCenter.ActWinterStormManager:ReqActInfo()
  end
  if actType == EnumActivity.ActMeteorite.Type then
    DataCenter.ActMeteoriteBattleManager:ReqGetActInfo()
  end
  if actType == EnumActivity.ActEpidemic.Type then
    DataCenter.ActEpidemicZoneManager:ReqActInfo()
  end
  if actType == EnumActivity.ActDsbDuel.Type then
    BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
  end
end

function RaceEntranceUtil.GetOpenShow(actType)
  local idx, tipKey, eTime, btnKey = 0, "", 0, "110036"
  if actType == EnumActivity.ActDragon.Type then
    local actMgr = DataCenter.ActDragonManager
    local actInfo = actMgr:GetActInfo()
    if actInfo ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < (actInfo.stopSignUpTime or 0) then
        idx = 1
        tipKey = "battlefield_entrance_ui1004"
        eTime = actInfo.stopSignUpTime / 1000
      elseif curTime < (actInfo.marchEndTime or 0) then
        idx = 2
        tipKey = "battlefield_entrance_ui1005"
        eTime = actInfo.marchEndTime / 1000
      elseif curTime < (actInfo.battleOpenTime or 0) then
        idx = 3
        tipKey = "battlefield_entrance_ui1006"
        eTime = actInfo.battleOpenTime / 1000
      else
        local myGroup = actMgr:GetMyGroup()
        local timeInfo = myGroup ~= nil and myGroup.timeInfo or nil
        if timeInfo ~= nil and curTime < timeInfo.prepTime then
          idx = 3
          tipKey = "battlefield_entrance_ui1006"
          eTime = timeInfo.prepTime / 1000
        elseif timeInfo ~= nil and curTime < timeInfo.endTime then
          idx = 4
          tipKey = "battlefield_entrance_ui1007"
          eTime = timeInfo.endTime / 1000
          btnKey = "458006"
        else
          idx = 5
          tipKey = "battlefield_entrance_ui1008"
          eTime = (actInfo.actEndTime or 0) / 1000
        end
      end
    else
      idx = 5
      tipKey = "battlefield_entrance_ui1008"
    end
  elseif actType == EnumActivity.ActWinterStorm.Type then
    local actMgr = DataCenter.ActWinterStormManager
    local actInfo = actMgr:GetActInfo()
    if actInfo ~= nil then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      if actInfo.battleBeginTime ~= nil and curSec < actInfo.battleBeginTime then
        eTime = actInfo.battleBeginTime
        tipKey = "battlefield_entrance_ui1009"
        idx = 1
      elseif actInfo.battleEndTime ~= nil and curSec >= actInfo.battleEndTime then
        eTime = actInfo.actEndTime
        tipKey = "battlefield_entrance_ui1008"
        idx = 6
      else
        local bInBattleTime, nextTime = actMgr:CheckInBattleTime()
        eTime = nextTime or actInfo.battleEndTime
        if bInBattleTime then
          local msTime = actMgr:GetMatchStartTime()
          if msTime ~= nil and msTime ~= 0 then
            tipKey = "battlefield_entrance_ui1010"
            btnKey = "winter_battlefield_tips1002"
            idx = 4
          else
            local remainTime = DataCenter.ActWinterStormManager:GetInBattleWorldLeftTime()
            if 0 < remainTime then
              tipKey = "battlefield_entrance_ui1007"
              btnKey = "458006"
              idx = 5
            else
              tipKey = "battlefield_entrance_ui1010"
              btnKey = "winter_battlefield_interface_tips1011"
              idx = 3
            end
          end
        else
          if nextTime then
            tipKey = "battlefield_entrance_ui1011"
          else
            tipKey = "battlefield_entrance_ui1008"
          end
          idx = 2
        end
      end
    else
      idx = 6
      tipKey = "battlefield_entrance_ui1008"
    end
  elseif actType == EnumActivity.ActMeteorite.Type then
    local actMgr = DataCenter.ActMeteoriteBattleManager
    local actInfo = actMgr:GetActInfo()
    if actInfo ~= nil then
      eTime = actInfo.stageEndTime
      local stage = actInfo.stage or MeteoriteState.MATCH
      if stage == MeteoriteState.SHOW then
        idx = 3
        tipKey = "battlefield_entrance_ui1008"
      elseif stage == MeteoriteState.GRAB then
        idx = 2
        tipKey = "battlefield_entrance_ui1007"
        btnKey = "110003"
      else
        idx = 1
        tipKey = "battlefield_entrance_ui1009"
      end
    end
  elseif actType == EnumActivity.ActEpidemic.Type then
    local stage, et = DataCenter.ActEpidemicZoneManager:FixStage()
    eTime = et
    if stage == EpidemicZoneStage.SignIn then
      idx = 1
      tipKey = "battlefield_entrance_ui1004"
    elseif stage == EpidemicZoneStage.Matching or stage == EpidemicZoneStage.MatchEnd then
      idx = 2
      tipKey = "battlefield_entrance_ui1005"
    elseif stage == EpidemicZoneStage.Prepare then
      idx = 3
      tipKey = "battlefield_entrance_ui1006"
    elseif stage == EpidemicZoneStage.Battle then
      idx = 4
      tipKey = "battlefield_entrance_ui1007"
      btnKey = "458006"
    elseif stage == EpidemicZoneStage.Show or stage == EpidemicZoneStage.End then
      idx = 5
      tipKey = "battlefield_entrance_ui1008"
    end
  elseif actType == EnumActivity.ActDsbDuel.Type then
    local actInfo = BattlefieldDsbDuelUtils.ActInfo
    if actInfo ~= nil then
      idx = actInfo:GetCurrentPhaseIndex()
      if actInfo:IsInSignUpPhase() then
        tipKey = "battlefield_entrance_ui1004"
      elseif actInfo:IsInGroupPhase() then
        tipKey = "battlefield_entrance_ui1005"
      elseif actInfo:IsInBattlePhase() then
        if actInfo:IsInTeamSignUpPhase() then
          tipKey = "battlefield_entrance_ui1004"
        elseif actInfo:IsInTeamMatchPhase() then
          tipKey = "battlefield_entrance_ui1005"
        elseif actInfo:IsInTeamWaitBattlePhase() then
          tipKey = "battlefield_entrance_ui1006"
        elseif actInfo:IsInTeamBattleReadyPhase() then
          tipKey = "battlefield_entrance_ui1009"
        elseif actInfo:IsInTeamBattlePhase() then
          tipKey = "battlefield_entrance_ui1007"
          btnKey = "458006"
        elseif actInfo:IsInTeamResultShowPhase() then
          tipKey = "battlefield_entrance_ui1008"
        end
      elseif actInfo:IsInResultShowPhase() then
        tipKey = "battlefield_entrance_ui1008"
      end
      local dsbSTime, dsbETime = actInfo:GetCurrentPhaseStartEndTime()
      eTime = dsbETime / 1000
    end
  end
  return idx, tipKey, eTime, btnKey
end

function RaceEntranceUtil.CheckCanShowTip(bBuild)
  local mainLv = DataCenter.BuildManager.MainLv or 0
  local actListMgr = DataCenter.ActivityListDataManager
  local activityData = actListMgr:GetOneOpenActivityByType(EnumActivity.ActDragon.Type)
  if activityData ~= nil and mainLv >= (EnumActivity.ActDragon.needMainCityLevel or 15) then
    local dragonMgr = DataCenter.ActDragonManager
    local myGroup = dragonMgr:GetMyGroup()
    if bBuild then
      if myGroup ~= nil and dragonMgr:InDragonBattleTime(myGroup.group) and myGroup:IsInMatch() then
        local timeInfo = myGroup ~= nil and myGroup.timeInfo or nil
        local endTime = timeInfo ~= nil and timeInfo.endTime or 0
        return EnumActivity.ActDragon.Type, true, nil, math.ceil(endTime / 1000)
      end
      for i = 1, 2 do
        local group = dragonMgr:GetGroup(i)
        if group ~= nil and not group:IsInGroup() and dragonMgr:InDragonBattleTime(group.group) and group:IsInMatch() then
          local timeInfo = group ~= nil and group.timeInfo or nil
          local endTime = timeInfo ~= nil and timeInfo.endTime or 0
          return EnumActivity.ActDragon.Type, false, nil, math.ceil(endTime / 1000)
        end
      end
    elseif myGroup ~= nil and dragonMgr:InDragonBattleTime(myGroup.group) and myGroup:IsInMatch() then
      local timeInfo = myGroup ~= nil and myGroup.timeInfo or nil
      local endTime = timeInfo ~= nil and timeInfo.endTime or 0
      return EnumActivity.ActDragon.Type, true, "battlefield_entrance_tips1004", math.ceil(endTime / 1000)
    end
  end
  activityData = actListMgr:GetOneOpenActivityByType(EnumActivity.ActWinterStorm.Type)
  if activityData ~= nil then
    local lv = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k14", 15)
    if mainLv >= lv then
      local winterMgr = DataCenter.ActWinterStormManager
      local flag, eTime = winterMgr:CheckInBattleTime()
      if flag then
        if bBuild then
          local remainTime = winterMgr:GetInBattleWorldLeftTime()
          if 0 < remainTime then
            local curSec = UITimeManager:GetInstance():GetServerSeconds()
            return EnumActivity.ActWinterStorm.Type, true, nil, curSec + remainTime
          end
        end
        local fFlag = winterMgr:IsAllRewardFinish()
        if bBuild then
          return EnumActivity.ActWinterStorm.Type, not fFlag, nil, eTime
        else
          return EnumActivity.ActWinterStorm.Type, not fFlag, "battlefield_entrance_tips1005", eTime
        end
      end
    end
  end
  activityData = actListMgr:GetOneOpenActivityByType(EnumActivity.ActMeteorite.Type)
  if activityData ~= nil then
    local meteoriteMgr = DataCenter.ActMeteoriteBattleManager
    if mainLv >= (EnumActivity.ActMeteorite.needMainCityLevel or 15) and meteoriteMgr:CheckIfActOpen() then
      local actInfo = meteoriteMgr:GetActInfo() or {}
      local stageEndTime = actInfo.stageEndTime or 0
      if actInfo.stage == MeteoriteState.GRAB then
        local fFlag = true
        local boxesConfig = meteoriteMgr:GetRewardBoxes(1)
        for _, v in pairs(boxesConfig) do
          local state = meteoriteMgr:GetBoxStateByCfg(v)
          if state ~= 3 then
            fFlag = false
            break
          end
        end
        if bBuild then
          return EnumActivity.ActMeteorite.Type, not fFlag, nil, stageEndTime
        else
          return EnumActivity.ActMeteorite.Type, not fFlag, "battlefield_entrance_tips1004", stageEndTime
        end
      else
        local curSec = UITimeManager:GetInstance():GetServerSeconds()
        if stageEndTime <= curSec then
          RaceEntranceUtil.ReqActInfo(EnumActivity.ActMeteorite.Type)
        end
      end
    end
  end
  activityData = actListMgr:GetOneOpenActivityByType(EnumActivity.ActEpidemic.Type)
  if activityData ~= nil and mainLv >= (EnumActivity.ActEpidemic.needMainCityLevel or 15) then
    local actMgr = DataCenter.ActEpidemicZoneManager
    if bBuild then
      local actInfo = actMgr:GetActInfo()
      if actInfo ~= nil and (actInfo.selfGroup ~= 0 or actInfo.selfAssigned ~= EpidemicZonePlayerState.None) then
        local stage, et = actMgr:FixStage(actInfo.selfGroup)
        if stage == EpidemicZoneStage.Battle then
          return EnumActivity.ActEpidemic.Type, true, nil, et
        end
      end
      for i = 1, 2 do
        local stage, et = actMgr:FixStage(i)
        if stage == EpidemicZoneStage.Battle then
          return EnumActivity.ActEpidemic.Type, false, nil, et
        end
      end
    elseif actMgr:CanShowEnter() then
      local myGroup = actMgr:GetMyGroup()
      local battleEndTime = myGroup ~= nil and myGroup.endTime
      return EnumActivity.ActEpidemic.Type, true, "battlefield_entrance_tips1004", battleEndTime
    end
  end
  activityData = actListMgr:GetOneOpenActivityByType(EnumActivity.ActDsbDuel.Type)
  if activityData ~= nil then
    local actInfo = BattlefieldDsbDuelUtils.ActInfo
    if mainLv >= (EnumActivity.ActDsbDuel.needMainCityLevel or 15) and actInfo:CheckIfActOpen() then
      if bBuild then
        if actInfo:IsInTeamBattlePhase() and actInfo:IsRegistered() and (actInfo:GetTeamState(BattlefieldDsbConst.TeamType.A) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess or actInfo:GetTeamState(BattlefieldDsbConst.TeamType.B) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess) then
          local _, endTime = actInfo:GetBattleTime()
          return EnumActivity.ActDsbDuel.Type, actInfo:GetSelfTeam() ~= BattlefieldDsbConst.TeamType.None, nil, math.ceil(endTime / 1000)
        end
      elseif actInfo:IsInTeamBattlePhase() and actInfo:IsRegistered() then
        local _, endTime = actInfo:GetBattleTime()
        return EnumActivity.ActDsbDuel.Type, true, "battlefield_entrance_tips1004", math.ceil(endTime / 1000)
      end
    end
  end
  if bBuild then
    local bNew = RaceEntranceUtil.IsNewOrUnlockByType(EnumActivity.ActDragon.Type)
    bNew = bNew or RaceEntranceUtil.IsNewOrUnlockByType(EnumActivity.ActWinterStorm.Type)
    bNew = bNew or RaceEntranceUtil.IsNewOrUnlockByType(EnumActivity.ActMeteorite.Type)
    bNew = bNew or RaceEntranceUtil.IsNewOrUnlockByType(EnumActivity.ActEpidemic.Type)
    bNew = bNew or RaceEntranceUtil.IsNewOrUnlockByType(EnumActivity.ActDsbDuel.Type)
    if bNew then
      return 0, true
    end
  end
  return -1, false
end

function RaceEntranceUtil.GotoOpenView(actType)
  if actType == nil or actType == 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRaceEntrance)
    return
  end
  local actInfo = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(actType)
  if actInfo == nil then
    return
  end
  if actType == EnumActivity.ActDragon.Type or actType == EnumActivity.ActWinterStorm.Type or actType == EnumActivity.ActEpidemic.Type then
    if RaceEntranceUtil.IsNewEntranceOpen() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRaceEntrance, {anim = true}, actType)
    else
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actInfo.id)
    end
  elseif actType == EnumActivity.ActMeteorite.Type then
    DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
  elseif actType == EnumActivity.ActDsbDuel.Type then
    BattlefieldDsbDuelUtils.ActInfo:OpenActWindow()
  end
end

local BUBBLE_PART0_PATH = "Assets/Main/TextureEx/UIRaceEntrance/part0/%s"
local BUBBLE_ICON_NEW = "Assets/Main/Sprites/UI/UILWNewsCenter/zyf_xinwen_new_icon.png"
local BUBBLE_ICON_DEF = "Assets/Main/Sprites/UI/UIBuildBubble/zxl_zhujiemian_qipao_zhanzheng.png"

function RaceEntranceUtil.GetBubbleIcon(actType, isBig)
  local tmpId
  if actType == -1 then
    return BUBBLE_ICON_DEF
  elseif actType == 0 then
    return BUBBLE_ICON_NEW
  elseif actType == EnumActivity.ActDragon.Type then
    tmpId = 1
  elseif actType == EnumActivity.ActWinterStorm.Type then
    tmpId = 2
  elseif actType == EnumActivity.ActMeteorite.Type then
    tmpId = 3
  elseif actType == EnumActivity.ActEpidemic.Type then
    tmpId = 4
  elseif actType == EnumActivity.ActDsbDuel.Type then
    tmpId = 5
  end
  if tmpId == nil then
    return nil
  end
  local fileName = GetTableData(TableName.BattleField_Entrance, tmpId, isBig and "big_bubble_icon" or "bubble_icon")
  if isBig then
    return string.format(BUBBLE_PART0_PATH, fileName)
  end
  return string.format(LoadPath.LWMainUINew, fileName)
end

function RaceEntranceUtil.IsNewOrUnlockByType(actType)
  if not RaceEntranceUtil.IsNewEntranceOpen() then
    return false
  end
  local template = RaceEntranceUtil.GetOneTemplate(actType)
  return RaceEntranceUtil.IsNewOrUnlock(template)
end

function RaceEntranceUtil.IsNewOrUnlock(template)
  if template ~= nil then
    local actType = template.type
    local OpenState = RaceEntranceUtil.OpenSate
    if template.state == OpenState.Open then
      local idx, _, endTime = RaceEntranceUtil.GetOpenShow(actType)
      if actType == EnumActivity.ActWinterStorm.Type and (idx < 3 or 5 < idx) then
        endTime = 0
      end
      if endTime == nil or endTime == 0 then
        return false
      end
      local time = CommonUtil.PlayerPrefsGetInt(SIGN_OPEN_KEY .. actType, 0)
      if time < UITimeManager:GetInstance():GetServerSeconds() then
        return true
      end
    elseif template.state ~= OpenState.Lock then
      return not CommonUtil.PlayerPrefsGetBool(SIGN_UNLOCK_KEY .. actType, false)
    end
  end
  return false
end

function RaceEntranceUtil.SignUnlock(actType)
  if not RaceEntranceUtil.IsNewEntranceOpen() then
    return
  end
  local template = RaceEntranceUtil.GetOneTemplate(actType)
  if template == nil then
    return
  end
  local key = SIGN_UNLOCK_KEY .. actType
  local flag = CommonUtil.PlayerPrefsGetBool(key, false)
  if flag then
    return
  end
  CommonUtil.PlayerPrefsSetBool(key, true)
end

function RaceEntranceUtil.SignNew(actType)
  if not RaceEntranceUtil.IsNewEntranceOpen() then
    return
  end
  local template = RaceEntranceUtil.GetOneTemplate(actType)
  if template == nil then
    return
  end
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(template.activity_id)
  if actInfo and actInfo:IsValid() then
    local endTime = toInt(actInfo.endTime / 1000)
    local key = SIGN_OPEN_KEY .. actType
    local time = CommonUtil.PlayerPrefsGetInt(key, 0)
    if time == endTime then
      return
    end
    CommonUtil.PlayerPrefsSetInt(key, endTime)
  end
end

function RaceEntranceUtil.IsNeedShowLoadingByType(actType, showTips, jumpToDC)
  local template = RaceEntranceUtil.GetOneTemplate(actType)
  if template then
    return RaceEntranceUtil.IsNeedShowLoading(template.activity_id, showTips, jumpToDC)
  end
  return false
end

function RaceEntranceUtil.IsNeedShowLoading(actId, showTips, jumpToDC)
  if CS.UnityEngine.Application.isEditor then
    return false
  end
  local actListMgr = DataCenter.ActivityListDataManager
  local bNeed = actListMgr:IsNeedCheckDownloadRes(actId)
  if not bNeed then
    return false
  end
  if actListMgr:IsDownloadResComplete(actId) then
    return false
  end
  if showTips then
    UIUtil.ShowTipsId("battlefield_entrance_tips1121")
  end
  if jumpToDC then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterMain, {anim = true, hideTop = true})
  end
  return true
end

function RaceEntranceUtil.CreateLoadingByType(actType, container, name, loadDownFunc, completeFunc)
  local list = RaceEntranceUtil.GetTemplates()
  local template = list[actType]
  if template then
    return RaceEntranceUtil.CreateLoading(template.activity_id, container, name, loadDownFunc, completeFunc)
  end
end

local CLS_DOWNLOADING = "UI/LWGift/BuyDiamond/Component/LWBuyDiamondResDownloadComponent"

function RaceEntranceUtil.CreateLoading(actId, container, name, loadDownFunc, completeFunc)
  local request = CS.GameEntry.Resource:InstantiateAsync(UIAssets.LWBuyDiamondDownloadRes)
  request:completed("+", function()
    if request.isError then
      return
    end
    local go = request.gameObject
    if not string.IsNullOrEmpty(name) then
      go.name = name
    end
    go.transform:SetParent(container.transform)
    go.transform:Set_localScale(1, 1, 1)
    local cls = require(CLS_DOWNLOADING)
    local comp = container:AddComponent(cls, go.name)
    comp:SetOffsetMinXY(0, 0)
    comp:SetOffsetMaxXY(0, 0)
    comp:SetActive(true)
    if loadDownFunc then
      loadDownFunc(comp)
    end
    comp:SetDataByActivityId(actId, completeFunc)
  end)
  return request
end

function RaceEntranceUtil.GetRaceEntranceInfo()
  local sb = StringBuilder.New()
  sb:AppendLine("\230\150\176\229\133\165\229\143\163\229\188\128\230\148\190 : " .. tostring(RaceEntranceUtil.IsNewEntranceOpen()))
  sb:AppendLine("\232\128\129\229\133\165\229\143\163\229\188\128\230\148\190 : " .. tostring(RaceEntranceUtil.IsOldEntranceOpen()))
  sb:AppendLine("\230\150\176\231\167\187\230\176\145\229\133\165\229\143\163\229\188\128\230\148\190 : " .. tostring(RaceEntranceUtil.IsNewMigration()))
  local nowSeason, seasonWeek = SeasonUtil.GetSeasonWeek()
  sb:AppendLine("\229\189\147\229\137\141\232\181\155\229\173\163 : " .. nowSeason)
  sb:AppendLine("\229\189\147\229\137\141\229\145\168 : " .. seasonWeek)
  sb:AppendLine("\229\189\147\229\137\141\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 : " .. UITimeManager:GetInstance():GetServerSeconds())
  sb:AppendLine("-----")
  sb:AppendLine("state\232\175\180\230\152\142 : ")
  sb:AppendLine("0 : Lock")
  sb:AppendLine("1 : UnLock")
  sb:AppendLine("2 : Coming")
  sb:AppendLine("3 : Open")
  sb:AppendLine("-----")
  local infos = {}
  infos[EnumActivity.ActDragon.Type] = "\230\178\153\230\188\160"
  infos[EnumActivity.ActWinterStorm.Type] = "\229\134\172\230\151\165"
  infos[EnumActivity.ActMeteorite.Type] = "\233\153\168\233\147\129"
  infos[EnumActivity.ActEpidemic.Type] = "\229\179\161\232\176\183"
  infos[EnumActivity.ActDsbDuel.Type] = "DSB"
  for actType, v in pairs(infos) do
    sb:AppendLine(v .. "unlockSign : " .. tostring(CommonUtil.PlayerPrefsGetBool(SIGN_UNLOCK_KEY .. actType, false)))
    sb:AppendLine(v .. "openSign : " .. CommonUtil.PlayerPrefsGetInt(SIGN_OPEN_KEY .. actType, 0))
    local template = RaceEntranceUtil.GetOneTemplate(actType)
    sb:AppendLine(v .. "state : " .. template.state)
    sb:AppendLine(v .. "comingTime : " .. template.comingTime)
    sb:AppendLine("-----")
  end
  return sb:ToString()
end

function RaceEntranceUtil.CleanSign()
  if not CommonUtil.IsDebug() then
    return "\228\184\141\230\152\175debug\239\188\129\230\184\133\231\144\134\229\164\177\232\180\165"
  end
  local list = RaceEntranceUtil.GetTemplates()
  for _, v in pairs(list) do
    CommonUtil.PlayerPrefsSetBool(SIGN_UNLOCK_KEY .. v.type, false)
    CommonUtil.PlayerPrefsSetInt(SIGN_OPEN_KEY .. v.type, 0)
  end
  return "\230\184\133\231\144\134\230\136\144\229\138\159"
end

return ConstClass("RaceEntranceUtil", RaceEntranceUtil)
