local LeagueMatchManager = BaseClass("LeagueMatchManager")
local LeagueMatchAllianceData = require("DataCenter.AllianceCompete.LeagueMatchAllianceData")
local Localization = CS.GameEntry.Localization
local CupPath = {
  [SegmentType.None] = "lrb_LMDJ_duanwei_3",
  [SegmentType.Bronze] = "lrb_LMDJ_duanwei_3",
  [SegmentType.Silver] = "lrb_LMDJ_duanwei_3",
  [SegmentType.Gold] = "lrb_LMDJ_duanwei_2",
  [SegmentType.Platinum] = "lrb_LMDJ_duanwei_1",
  [SegmentType.Diamond] = "lrb_LMDJ_duanwei_1"
}
local CupBgPath = {
  [SegmentType.None] = "lrb_LMDJ_duanwei_lan",
  [SegmentType.Bronze] = "lrb_LMDJ_duanwei_lan",
  [SegmentType.Silver] = "lrb_LMDJ_duanwei_lan",
  [SegmentType.Gold] = "lrb_LMDJ_duanwei_jin",
  [SegmentType.Platinum] = "lrb_LMDJ_duanwei_zi",
  [SegmentType.Diamond] = "lrb_LMDJ_duanwei_zi"
}
local CupLangKey = {
  [SegmentType.None] = 459002,
  [SegmentType.Bronze] = 459003,
  [SegmentType.Silver] = 459003,
  [SegmentType.Gold] = 459004,
  [SegmentType.Platinum] = 459006,
  [SegmentType.Diamond] = 459006
}
local RAW_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/%s.png"

function LeagueMatchManager:__init()
  self.leagueMatchBaseInfo = nil
  self.myMatchInfo = nil
  self.matchGroupAlList = {}
  self.lastMatchGroupAlList = {}
  self.rewardDic = {}
  self.warmRewardInfo = {}
  self.upCount = -1
  self.downCount = -1
  self.isMatchOpen = false
  self.weekHistory = {}
  self.weekHistoryRefreshTS = 0
  self.myAllyCurRank = nil
  self.curRankInAlly = nil
  self.curScoreThisMonth = 0
end

function LeagueMatchManager:__delete()
  self.leagueMatchBaseInfo = nil
  self.myMatchInfo = nil
  self.matchGroupAlList = nil
  self.lastMatchGroupAlList = nil
end

function LeagueMatchManager:OnRecvInitMsg(msg)
  if msg then
    if msg.allianceDuel then
      self:UpdateLeagueMatchBaseInfo(msg.allianceDuel)
    end
    if msg.isOpen then
      self.isMatchOpen = msg.isOpen == 1
    end
  end
end

function LeagueMatchManager:OnRecvSeasonChangePush(msg)
  if msg and msg.allianceDuel then
    self:UpdateLeagueMatchBaseInfo(msg.allianceDuel)
  end
  self:GetMyMatchInfoReq()
  EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchBaseInfoUpdate)
end

function LeagueMatchManager:PushHasLeaveAlDuelConfirm(msg)
  if msg.hasLeaveAlDuelConfirm ~= nil then
    self.hasLeaveAlDuelConfirm = msg.hasLeaveAlDuelConfirm
  end
end

function LeagueMatchManager:UpdateLeagueMatchBaseInfo(msg)
  if msg.actInfo then
    self.leagueMatchBaseInfo = msg.actInfo
  end
  if msg.crossMoveCDEnd then
    self:SetCrossMoveCDEnd(msg.crossMoveCDEnd)
  end
  if msg.hasLeaveAlDuelConfirm ~= nil then
    self.hasLeaveAlDuelConfirm = msg.hasLeaveAlDuelConfirm
  end
  if msg.isParticipating ~= nil then
    self.isParticipating = msg.isParticipating
  end
  if self.leagueMatchBaseInfo and self.leagueMatchBaseInfo.drawStartTime then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    if serverTime < self.leagueMatchBaseInfo.drawStartTime then
      local delayS = math.ceil((self.leagueMatchBaseInfo.drawStartTime - serverTime) / 1000)
      TimerManager:GetInstance():DelayInvoke(function()
        EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchStageChange)
      end, delayS + 2)
    end
  end
end

function LeagueMatchManager:GetMyMatchInfoReq()
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetMyLeagueMatchInfo)
  end
end

function LeagueMatchManager:OnRecvMyMatchInfoResp(t)
  self.myMatchInfo = t
  EventManager:GetInstance():Broadcast(EventId.OnMyLeagueMatchInfoUpdate)
end

function LeagueMatchManager:GetCurSeasonGroupReq()
  SFSNetwork.SendMessage(MsgDefines.GetCurSeasonLeagueMatchGroupInfo)
end

function LeagueMatchManager:OnRecvMatchGroupResp(t)
  self:UpdateMatchGroupInfo(t)
  EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchGroupUpdate)
end

function LeagueMatchManager:UpdateMatchGroupInfo(t)
  if t.groupInfos then
    self.matchGroupAlList = {}
    for i, v in ipairs(t.groupInfos) do
      if not v.fake or v.fake ~= 1 then
        local alInfo = LeagueMatchAllianceData.New()
        alInfo:ParseData(v, i)
        table.insert(self.matchGroupAlList, alInfo)
        if alInfo.allianceId == LuaEntry.Player.allianceId then
          self.myAllyCurRank = i
        end
      end
    end
  end
  if t.up then
    self.upCount = t.up
  end
  if t.down then
    self.downCount = t.down
  end
end

function LeagueMatchManager:GetLastSeasonGroupReq()
  SFSNetwork.SendMessage(MsgDefines.GetLastSeasonLeagueMatchGroupInfo)
end

function LeagueMatchManager:OnRecvLastMatchGroupResp(t)
  self:UpdateLastMatchGroupInfo(t)
  EventManager:GetInstance():Broadcast(EventId.OnLastLeagueMatchGroupInfoUpdate)
end

function LeagueMatchManager:UpdateLastMatchGroupInfo(t)
  if t.groupInfos then
    self.lastMatchGroupAlList = {}
    for i, v in ipairs(t.groupInfos) do
      if not v.fake or v.fake ~= 1 then
        local alInfo = LeagueMatchAllianceData.New()
        alInfo:ParseData(v, i)
        table.insert(self.lastMatchGroupAlList, alInfo)
      end
    end
  end
end

function LeagueMatchManager:DrawLotsReq()
  SFSNetwork.SendMessage(MsgDefines.LeagueMatchDrawLots)
end

function LeagueMatchManager:OnRecvDrawLotsResultResp(msg)
  if msg.position then
    if self.myMatchInfo and self.myMatchInfo.duelInfo then
      self.myMatchInfo.duelInfo.position = msg.position
    end
    for i, v in ipairs(self.matchGroupAlList) do
      if v.allianceId == LuaEntry.Player.allianceId then
        v.position = msg.position
        break
      end
    end
    local strTip = Localization:GetString("372627", msg.position)
    UIUtil.ShowMessage(strTip, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, nil, nil)
  end
  EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchGroupUpdate)
end

function LeagueMatchManager:GetLeagueMatchRewardInfoReq(type)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if self.rewardDic[type] == nil or self.lastRewardReq and now - self.lastRewardReq > 60 then
    SFSNetwork.SendMessage(MsgDefines.GetLeagueMatchRewardInfo, type)
    self.lastRewardReq = now
  end
end

function LeagueMatchManager:OnRecvLeagueMatchRewardInfoResp(msg)
  if msg.userRankRewards then
    self.rewardDic[1] = msg.userRankRewards
  elseif msg.allianceRewards then
    self.rewardDic[2] = msg.allianceRewards
  elseif msg.seasonRewards then
    self.rewardDic[3] = msg.seasonRewards
    self.curRankInAlly = msg.curRank
    self.curScoreThisMonth = msg.score or 0
  end
  EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchRewardInfoUpdate)
end

function LeagueMatchManager:GetLeagueMatchWarmRewardInfoReq()
  SFSNetwork.SendMessage(MsgDefines.GetLeagueMatchWarmRewardInfo)
end

function LeagueMatchManager:OnRecvLeagueMatchWarmRewardResp(msg)
  self.warmRewardInfo = msg
  EventManager:GetInstance():Broadcast(EventId.OnLeagueMatchRewardInfoUpdate)
end

function LeagueMatchManager:CheckIsOpenForReward()
  return self.myMatchInfo and self.myMatchInfo.duelInfo
end

function LeagueMatchManager:IsLeagueOpen()
  return self.leagueMatchBaseInfo
end

function LeagueMatchManager:GetLeagueMatchBaseInfo()
  return self.leagueMatchBaseInfo
end

function LeagueMatchManager:CheckIsMatchOpen()
  return self.isMatchOpen
end

function LeagueMatchManager:ResetMyDuelInfo()
  if self.myMatchInfo then
    self.myMatchInfo.duelInfo = nil
    self.myMatchInfo.lastDuelInfo = nil
    self.myMatchInfo = nil
  end
end

function LeagueMatchManager:GetMatchGroupInfo()
  return self.matchGroupAlList
end

function LeagueMatchManager:GetDrawLotsGroupDic()
  local retTb = {}
  for i, v in ipairs(self.matchGroupAlList) do
    retTb[v.position] = v
  end
  return retTb
end

function LeagueMatchManager:GetLastMatchGroupInfo()
  return self.lastMatchGroupAlList
end

function LeagueMatchManager:GetMyMatchInfo()
  return self.myMatchInfo
end

function LeagueMatchManager:GetLastOrCurMatchGroupInfo()
  local tempStage = self:GetLeagueMatchStage()
  if tempStage == LeagueMatchStage.Preview then
    return self.lastMatchGroupAlList
  else
    return self.matchGroupAlList
  end
end

function LeagueMatchManager:GetLeagueMatchStage()
  if not self.leagueMatchBaseInfo then
    return LeagueMatchStage.None
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.leagueMatchBaseInfo.seasonStartTime then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.AllianceCompete.Type)
    if dataList and dataList[1] and dataList[1].preOpenTime then
      return LeagueMatchStage.Preview
    else
      return LeagueMatchStage.None
    end
  elseif curTime < self.leagueMatchBaseInfo.seasonEndTime then
    if not self:GetHasSeenGroupResult() then
      return LeagueMatchStage.GroupResult
    end
    local weekday = UITimeManager:GetInstance():GetWeekdayIndex(curTime)
    if weekday == 7 then
      if self.leagueMatchBaseInfo.seasonEndTime - curTime > OneDayTime * 1000 then
        return LeagueMatchStage.WeeklySummary
      else
        return LeagueMatchStage.FinalSummary
      end
    else
      return LeagueMatchStage.Compete
    end
  else
    return LeagueMatchStage.FinalSummary
  end
end

function LeagueMatchManager:GetRewardInfo(type, seg)
  if seg == SegmentType.None then
    if not (type ~= 1 or self.warmRewardInfo.userRankRewards) or type == 2 and not self.warmRewardInfo.dailyWinReward then
      self:GetLeagueMatchWarmRewardInfoReq()
    elseif type == 1 then
      return self.warmRewardInfo.userRankRewards
    elseif type == 2 then
      local retTb = {
        dailyWinReward = self.warmRewardInfo.dailyWinReward,
        weekWinReward = self.warmRewardInfo.weekWinReward,
        weekFailReward = self.warmRewardInfo.weekFailReward,
        requireDailyPoint = self.warmRewardInfo.requireDailyPoint,
        requireWeekPoint = self.warmRewardInfo.requireWeekPoint
      }
      return retTb
    end
  elseif self.rewardDic[type] then
    if type == 1 then
      for i, v in ipairs(self.rewardDic[type]) do
        if v.rankType == seg then
          return v.rankRewards
        end
      end
    elseif type == 2 then
      for i, v in ipairs(self.rewardDic[2]) do
        if v.rankType == seg then
          local retTb = {
            dailyWinReward = v.dailyWinReward,
            weekWinReward = v.weekWinReward,
            weekFailReward = v.weekFailReward,
            requireDailyPoint = v.requireDailyPoint,
            requireWeekPoint = v.requireWeekPoint
          }
          return retTb
        end
      end
    elseif type == 3 then
      for i, v in ipairs(self.rewardDic[3]) do
        if v.rankType == seg then
          return v.allianceRankRewards, v.requireSeasonPoint
        end
      end
    end
  else
    self:GetLeagueMatchRewardInfoReq(type)
    return nil
  end
end

function LeagueMatchManager:TryUpdateLeagueMatchGroup()
  local tempStage = self:GetLeagueMatchStage()
  if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
    if self.myMatchInfo and self.myMatchInfo.lastDuelInfo then
      self:GetLastSeasonGroupReq()
    end
  elseif self.myMatchInfo and self.myMatchInfo.duelInfo then
    self:GetCurSeasonGroupReq()
  end
end

function LeagueMatchManager:GetMyCurDuelInfo(bLast)
  if not self.myMatchInfo then
    return nil
  end
  local tempStage = self:GetLeagueMatchStage()
  if bLast or tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
    return self.myMatchInfo.lastDuelInfo
  else
    return self.myMatchInfo.duelInfo
  end
end

function LeagueMatchManager:GetUpDownCount()
  return self.upCount, self.downCount
end

function LeagueMatchManager:CheckAllianceInMatch()
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if not isInAlliance then
    return false
  elseif self.myMatchInfo and self.myMatchInfo.duelInfo then
    return true
  else
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if actInfo then
      return true
    end
    return false
  end
end

function LeagueMatchManager:CheckIfInMatch()
  if not self:CheckIsMatchOpen() then
    return false
  end
  local tempStage = self:GetLeagueMatchStage()
  local myMatchInfo = self:GetMyMatchInfo()
  if myMatchInfo then
    if tempStage == LeagueMatchStage.Preview or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
      return myMatchInfo.lastDuelInfo
    else
      return myMatchInfo.duelInfo
    end
  else
    return nil
  end
end

function LeagueMatchManager:CheckIsSubmitting()
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  local weekIndex = UITimeManager:GetInstance():GetWeekdayIndex(serverTimeS * 1000)
  if weekIndex == 7 then
    local todayZero = UITimeManager:GetInstance():GetTodayZeroServerTime(serverTimeS)
    local offsetTimeS = serverTimeS - todayZero
    if 0 <= offsetTimeS and offsetTimeS <= OneHourTime then
      return true
    end
  end
  return false
end

function LeagueMatchManager:GetCrossMoveCDEnd()
  return self.crossMoveCDEnd
end

function LeagueMatchManager:SetCrossMoveCDEnd(cd)
  self.crossMoveCDEnd = cd
  if CS.CommonUtils.IsDebug() then
    local now = UITimeManager:GetInstance():GetServerTime()
    Logger.LogInfo(string.format("CrossServer.CD.Update (%s, %s)", cd, now))
  end
end

function LeagueMatchManager:HasLeaveAlDuelConfirm()
  return self.hasLeaveAlDuelConfirm
end

function LeagueMatchManager:GetHasSeenGroupResult()
  if not self.leagueMatchBaseInfo then
    return false
  end
  local seasonNum = CommonUtil.PlayerPrefsGetInt("LAST_TIME_SEEN_GROUP_RESULT", -1)
  return self.leagueMatchBaseInfo.season == seasonNum
end

function LeagueMatchManager:SetHasSeenGroupResult()
  if self.leagueMatchBaseInfo and self.leagueMatchBaseInfo.season then
    CommonUtil.PlayerPrefsSetInt("LAST_TIME_SEEN_GROUP_RESULT", self.leagueMatchBaseInfo.season)
  end
end

function LeagueMatchManager:FetchAlBattleAllWeekVsInfo(maxWeek)
  if not self.leagueMatchBaseInfo then
    return
  end
  for i = 1, maxWeek - 1 do
    if self.weekHistory[i] == nil then
      SFSNetwork.SendMessage(MsgDefines.AlBattleAllWeekVsInfo, i)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.AlBattleAllWeekVsInfo, maxWeek)
end

function LeagueMatchManager:OnRecvAlBattleAllWeekVsInfo(t)
  if not t.week then
    return
  end
  self.weekHistory[t.week] = t.data
  EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueHistory)
end

function LeagueMatchManager:GetMyScoreThisMonth()
  return self.curScoreThisMonth
end

function LeagueMatchManager:GetWeekVsInfo(week)
  return self.weekHistory[week]
end

function LeagueMatchManager:GetWeekCount()
  if not self.leagueMatchBaseInfo then
    return 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local past = now - self.leagueMatchBaseInfo.seasonStartTime
  local week = math.ceil(past / 604800000)
  return week
end

function LeagueMatchManager:GetMyAllyCurRank()
  return self.myAllyCurRank
end

function LeagueMatchManager:GetCurRankInAlly()
  return self.curRankInAlly
end

function LeagueMatchManager:IsParticipatingAllyDuel()
  return self.isParticipating == 1
end

function LeagueMatchManager:GetMissions(heroEventCfg)
  local score_way_icon = string.split(heroEventCfg.score_way_icon, ",")
  local score_way_name = string.split(heroEventCfg.score_way_name, ",")
  if #score_way_icon ~= #score_way_name then
    Logger.LogError("\233\133\141\231\189\174\233\148\153\232\175\175\239\188\154heroevent\232\161\168" .. heroEventCfg.id .. "\232\161\140score_way_icon\229\136\151\228\184\142score_way_name\229\136\151\228\184\141\229\175\185\229\186\148\239\188\129")
  end
  local missionHisStr = CommonUtil.PlayerPrefsGetString("UIAllyDuelPopupViewMission", "")
  local missionHistory = string.split(missionHisStr, ",")
  local missionHisDic = {}
  for _, v in pairs(missionHistory) do
    missionHisDic[v] = true
  end
  local mission = {}
  for i, v in ipairs(score_way_name) do
    mission[i] = {
      icon = score_way_icon[i],
      name = v,
      new = 0
    }
  end
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  local seasonNum = SeasonUtil.GetSeason()
  local seasonDay = SeasonUtil.GetSeasonDay()
  local openServerWeek = UITimeManager:GetInstance():GetOpenServerWeek()
  local score_way_icon_name_addition = string.split(heroEventCfg.score_way_icon_name_addition, "|")
  for _, v in ipairs(score_way_icon_name_addition) do
    local spl = string.split(v, ",")
    if #spl == 4 then
      local condi = tonumber(spl[1])
      local param
      if condi == 2 then
        param = string.split(spl[2], "#")
        param[1] = tonumber(param[1])
        if param[2] then
          param[2] = tonumber(param[2])
        else
          param[2] = 1
        end
      else
        param = tonumber(spl[2])
      end
      local icon = spl[3]
      local name = spl[4]
      if condi == 1 and openServerDay >= param or condi == 2 and (seasonNum > param[1] or param[1] == seasonNum and seasonDay >= param[2]) or condi == 3 and openServerWeek >= param then
        if missionHisDic[name] then
          table.insert(mission, {
            icon = icon,
            name = name,
            new = 1
          })
        else
          missionHisStr = missionHisStr .. "," .. name
          table.insert(mission, {
            icon = icon,
            name = name,
            new = 2
          })
        end
      end
    end
  end
  CommonUtil.PlayerPrefsSetString("UIAllyDuelPopupViewMission", missionHisStr)
  table.sort(mission, function(a, b)
    return a.new > b.new
  end)
  return mission
end

function LeagueMatchManager:BNewPop()
  return false
end

function LeagueMatchManager:SetCup(cup, cupBg, cupTxt, bLast)
  local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo(bLast)
  if duelInfo == nil or duelInfo.rankType == nil then
    cupBg:SetAlpha(0)
    cup:SetAlpha(0)
    cupTxt:SetText("")
    return
  end
  cupBg:SetAlpha(1)
  cupBg:LoadSpriteAuto(string.format(RAW_PATH, CupBgPath[duelInfo.rankType]))
  cup:SetAlpha(1)
  cup:LoadSpriteAuto(string.format(RAW_PATH, CupPath[duelInfo.rankType]))
  local curWeek = math.max(1, DataCenter.LeagueMatchManager:GetWeekCount())
  local groupStr = Localization:GetString(CupLangKey[duelInfo.rankType])
  local strArr = string.split(duelInfo.group, "_")
  local groupName = Localization:GetString("459013", groupStr, strArr[1], strArr[3], curWeek)
  cupTxt:SetText(groupName)
end

function LeagueMatchManager:GetGroupName(bLast)
  local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo(bLast)
  if duelInfo == nil or duelInfo.rankType == nil then
    return "", "", ""
  end
  local prev = math.max(SegmentType.None, duelInfo.rankType - 1)
  local next = math.min(3, duelInfo.rankType + 1)
  return Localization:GetString(CupLangKey[prev]), Localization:GetString(CupLangKey[next]), Localization:GetString(CupLangKey[duelInfo.rankType])
end

function LeagueMatchManager:GetSegment(bLast)
  local targetSeg = SegmentType.Silver
  local rankType = SegmentType.None
  local matchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
  local duelInfo
  if bLast then
    duelInfo = matchInfo and matchInfo.lastDuelInfo
  else
    duelInfo = matchInfo and matchInfo.duelInfo
  end
  if duelInfo then
    rankType = duelInfo.rankType
    if rankType == SegmentType.Silver then
      targetSeg = SegmentType.Silver
    elseif rankType == SegmentType.Gold then
      targetSeg = SegmentType.Gold
    else
      targetSeg = SegmentType.Diamond
    end
  end
  return targetSeg, rankType
end

local LEAGUE_SEASON_POP = "_LEAGUE_SEASON_POP_"

function LeagueMatchManager:CheckSeasonGradePopSign()
  local baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
  local season = baseInfo ~= nil and baseInfo.season or 1
  if season <= 1 then
    return
  end
  local lastInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo(true)
  if table.IsNullOrEmpty(lastInfo) then
    return
  end
  local key = LEAGUE_SEASON_POP .. season
  local flag = CommonUtil.PlayerPrefsGetBool(key, false)
  if flag then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuelLeagueGradeStatePop, {anim = false})
end

function LeagueMatchManager:SignGradeChangePop()
  local baseInfo = DataCenter.LeagueMatchManager:GetLeagueMatchBaseInfo()
  local season = baseInfo ~= nil and baseInfo.season or 1
  local key = LEAGUE_SEASON_POP .. season
  CommonUtil.PlayerPrefsSetBool(key, true)
end

return LeagueMatchManager
