local AllianceCompeteDataManager = BaseClass("AllianceCompeteDataManager")
local AllianceCityOccupyInfo = require("DataCenter.WorldAllianceCityData.AllianceCityOccupyInfo")

local function __init(self)
  self.heroEventInfo = nil
  self.rankInfoDic = {}
  self.dailyRank = {}
  self.recommendPoint = 0
end

local function __delete(self)
  self.heroEventInfo = nil
  self.rankInfoDic = nil
  self.dailyRank = nil
  self.recommendPoint = 0
end

local function RefreshWeekResultVS(self, message)
  if message == nil then
    return
  end
  local activity = message
  if activity.vsAllianceInfo ~= nil then
    local vsAllianceInfo = activity.vsAllianceInfo
    self.vsAllianceList = {}
    table.walk(vsAllianceInfo, function(k, v)
      local allianceId = v.allianceId
      self.vsAllianceList[allianceId] = {}
      self.vsAllianceList[allianceId].id = allianceId
      self.vsAllianceList[allianceId].alName = v.alName
      self.vsAllianceList[allianceId].abbr = v.abbr
      self.vsAllianceList[allianceId].icon = v.icon
      self.vsAllianceList[allianceId].alScore = v.alScore
      self.vsAllianceList[allianceId].win = v.win
      self.vsAllianceList[allianceId].winScore = v.winScore
      self.vsAllianceList[allianceId].serverId = v.serverId
    end)
  end
  if message.mvpPlayer ~= nil then
    local mvpPlayer = message.mvpPlayer
    self.vsAllianceList_mvpPlayer = {}
    self.vsAllianceList_mvpPlayer.uid = mvpPlayer.uid
    self.vsAllianceList_mvpPlayer.pic = mvpPlayer.pic
    self.vsAllianceList_mvpPlayer.picVer = mvpPlayer.picVer
    self.vsAllianceList_mvpPlayer.name = mvpPlayer.name
  end
  if message.finishTime ~= nil then
    self.vsAllianceList_finishTime = message.finishTime
  end
  if message.isWin ~= nil then
    self.vsAllianceList_isWin = message.isWin
    EventManager:GetInstance():Broadcast(EventId.Nofity_Alliance_Battle_Week_Rusult_VS)
  end
end

local function FetchRankList(self, type, day)
  SFSNetwork.SendMessage(MsgDefines.AllianceCompeteRankList, type, day)
end

local function RefreshRankList(self, message)
  if message.rankInfo then
    if not message.type then
      Logger.LogError("NoRankTypeError")
      return
    end
    local rankArray = message.rankInfo
    local rankList = {}
    table.walk(rankArray, function(k, v)
      table.insert(rankList, v)
    end)
    local type = message.type
    if type == 0 then
      local weekDayIndex
      if message.day then
        weekDayIndex = message.day
      else
        weekDayIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
      end
      self.dailyRank[weekDayIndex] = rankList
    else
      self.rankInfoDic[type] = rankList
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceCompeteRankListUpdated)
  end
end

local function RefreshWeeklySummaryMsg(self, message)
  if message.resultArray then
    local resultArray = message.resultArray
    self.weekResultViewList = {}
    self.weekResultViewStartTime = message.startTime
    table.walk(resultArray, function(k, v)
      table.insert(self.weekResultViewList, v)
    end)
    self.extraActivitys = message.extraActivitys
    EventManager:GetInstance():Broadcast(EventId.AllianceCompeteWeeklySummaryUpdated)
  end
end

local function GetVSAllianceList(self)
  return self.vsAllianceList
end

local function GetFinishTime(self)
  return self.vsAllianceList_finishTime
end

local function GetRankList(self, rankType, day)
  if rankType == AllyDuelRankType.Day then
    day = day or UITimeManager:GetInstance():GetNowWeekdayIndex()
    return self.dailyRank[day] or {}
  end
  return self.rankInfoDic[rankType] or {}
end

function AllianceCompeteDataManager:GetRankListState(rankType, day)
  if rankType == AllyDuelRankType.Day then
    day = day or UITimeManager:GetInstance():GetNowWeekdayIndex()
    return self.dailyRank[day]
  end
  return self.rankInfoDic[rankType]
end

local function GetWeeklySummaryList(self)
  return self.weekResultViewList
end

local function GetExtraActivityList(self)
  return self.extraActivitys
end

local function GetWeeklySummaryStartTime(self)
  return self.weekResultViewStartTime
end

local function CheckIfIsInCompete(self)
  local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not alCompeteInfo then
    return false
  end
  local eventInfo = alCompeteInfo:GetEventInfo()
  if eventInfo == nil or eventInfo.vsAllianceList == nil then
    return false
  end
  return true
end

local function GetFightServerId(self)
  local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if alCompeteInfo then
    local eventInfo = alCompeteInfo:GetEventInfo()
    if eventInfo then
      return eventInfo.targetServerId
    end
  end
  return 0
end

local function CheckCanMoveCityToServer(self, serverId)
  if serverId == LuaEntry.Player:GetSourceServerId() then
    return true
  end
  local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not alCompeteInfo then
    return false
  end
  local eventInfo = alCompeteInfo:GetEventInfo()
  if not eventInfo or serverId ~= eventInfo.targetServerId then
    return false
  end
  local hasOpponent, startT, endT = eventInfo:CheckIfShowCrossServer()
  if not hasOpponent then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if startT < now and endT > now then
    return true
  end
  return false
end

function AllianceCompeteDataManager:IsBattleDay()
  local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not alCompeteInfo then
    return false
  end
  local eventInfo = alCompeteInfo:GetEventInfo()
  if not eventInfo then
    return false
  end
  local hasOpponent, startT, endT = eventInfo:CheckIfShowCrossServer()
  if not hasOpponent then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if startT < now and endT > now then
    return true
  end
  return false
end

local function GetCrossServerEndTime(self)
  local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if alCompeteInfo then
    local eventInfo = alCompeteInfo:GetEventInfo()
    if eventInfo then
      return eventInfo.endTime
    end
  end
  return 0
end

local function GetFightAllianceId(self)
  if LuaEntry.Player:IsInAlliance() then
    local allianceActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if allianceActInfo ~= nil then
      local eventInfo = allianceActInfo:GetEventInfo()
      if eventInfo ~= nil and eventInfo.crossFight > 0 then
        return eventInfo.targetAllianceId
      end
    end
  end
  return ""
end

local function CacheOpeningTabIndex(self, tempTab)
  self.cacheTabIndex = tempTab
end

local function GetDefaultOpenTabIndex(self)
  local actRedCount = self:GetAlCompeteActivityRedCount()
  if 0 < actRedCount then
    return LeagueMatchTab.Activity
  else
    return self.cacheTabIndex or LeagueMatchTab.Compete
  end
end

local function GetAlCompeteteTotalRedCount(self)
  local totalCount = 0
  local actRed, reward, tip = self:GetAlCompeteActivityRedCount()
  totalCount = actRed + totalCount
  return totalCount, reward, tip
end

local function GetAlCompeteActivityRedCount(self)
  local redCount, reward, tip = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.AllianceCompete.Type, EnumActivity.AllianceCompete.ActId)
  return redCount, reward, tip
end

local function RequestFightServerAllianceCity(self)
  local fightServerId = self:GetFightServerId()
  if fightServerId ~= nil then
    SFSNetwork.SendMessage(MsgDefines.GetWorldCityInfo, fightServerId)
    if SeasonUtil.IsInSeasonCityStrongholdMode() or SeasonUtil.IsInSeasonSnowMode() then
      SFSNetwork.SendMessage(MsgDefines.GetWorldCityStrongholdInfo, fightServerId)
    end
    if SeasonUtil.IsInSeasonMummyMode() or SeasonUtil.IsInSeasonDarknessMode() then
      SFSNetwork.SendMessage(MsgDefines.WorldGetSuppliesCityInfo, fightServerId)
    end
  end
end

local function GetPersonalRank(self)
  local rankList = self:GetRankList(AllyDuelRankType.Day)
  local rankIndex = 0
  for i = 1, #rankList do
    local data = rankList[i]
    local uid = data.uid
    if uid ~= nil and uid == LuaEntry.Player.uid then
      local score = data and data.score or 0
      if 0 < score then
        rankIndex = i
      end
      break
    end
  end
  return rankIndex
end

function AllianceCompeteDataManager:CheckIfAllianceCompeteOpen()
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_duel")
  if not configOpenState then
    return false
  end
  local isGachaUnlock = DataCenter.AllyDuelScoreGachaManager:IsUnlock()
  if isGachaUnlock then
    return true
  end
  local mainLv = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  local isLeagueOpen = DataCenter.LeagueMatchManager:CheckIsMatchOpen()
  if activityInfo then
    local now = UITimeManager:GetInstance():GetServerTime()
    local weekIndex = UITimeManager:GetInstance():GetWeekdayIndex(now)
    if weekIndex == 7 and not isLeagueOpen then
      return false
    end
    if activityInfo.preOpenTime then
      return false
    end
    mainLv = activityInfo.needMainCityLevel
  elseif isLeagueOpen then
    local matchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
    local duelInfo = matchInfo and matchInfo.duelInfo
    if duelInfo then
      if duelInfo.roundResult then
        local results = string.split(duelInfo.roundResult, ";")
        if results[4] then
          return false
        end
      end
      mainLv = LuaEntry.DataConfig:TryGetNum("alliance_legend2", "k2")
    else
      local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
      if tempStage == LeagueMatchStage.Preview then
        return true
      else
        return false
      end
    end
  else
    return false
  end
  local mainBuildLV = DataCenter.BuildManager.MainLv
  if mainBuildLV and mainLv > mainBuildLV then
    return false
  else
    return true
  end
end

function AllianceCompeteDataManager:CheckShowPopup()
  if not self:CheckOpenAllianceCompeteAndVs() then
    return false
  end
  local timeMgr = UITimeManager:GetInstance()
  local lastOpenTime = CommonUtil.PlayerPrefsGetLong("ALLY_DUEL_POPUP_WEEK_TIMESTAMP", 0)
  if 0 < lastOpenTime and timeMgr:CheckIfIsSameWeek(lastOpenTime) then
    return false
  end
  lastOpenTime = CommonUtil.PlayerPrefsGetLong("ALLY_DUEL_POPUP_TIMESTAMP", 0)
  local todayZero = timeMgr:TodayZero()
  return lastOpenTime < todayZero
end

function AllianceCompeteDataManager:CheckOpenAllianceCompeteAndVs()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityInfo == nil then
    return false
  end
  if activityInfo.preOpenTime ~= nil then
    return false
  end
  local eventInfo = activityInfo:GetEventInfo()
  if eventInfo == nil then
    return false
  end
  local vsAllianceList = eventInfo.vsAllianceList
  if not vsAllianceList or table.count(vsAllianceList) == 0 then
    return false
  end
  return true
end

function AllianceCompeteDataManager:CheckShowProtectCoverPopup()
  local now = UITimeManager:GetInstance():GetServerTime()
  local lastOpenMonth = CommonUtil.PlayerPrefsGetLong("PROTECT_COVER_TIP_MONTH_FLAG", 0)
  if 0 < lastOpenMonth then
    local time = math.modf(now / 1000)
    local format = os.date("!*t", time)
    if format.month == lastOpenMonth then
      return false
    end
  end
  local weekIndex = UITimeManager:GetInstance():GetWeekdayIndex(now)
  local countStr = CommonUtil.PlayerPrefsGetString("PROTECT_COVER_TIP_DAILY_COUNT", "")
  local flagCount = false
  local limitCount = LuaEntry.DataConfig:TryGetNum("alliance_duel_warday_forewarning_popupimage_times", "k1", 0)
  if not string.IsNullOrEmpty(countStr) then
    local day_count = string.split(countStr, "_")
    local day = tonumber(day_count[1])
    local count = tonumber(day_count[2])
    local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
    if day ~= today then
      day = today
      count = 0
      CommonUtil.PlayerPrefsSetString("PROTECT_COVER_TIP_DAILY_COUNT", tostring(day) .. "_" .. tostring(count))
    end
    flagCount = limitCount > count
  else
    flagCount = 0 < limitCount
  end
  if flagCount and weekIndex == 5 and self:CheckOpenAllianceCompeteAndVs() then
    return true
  end
  return false
end

function AllianceCompeteDataManager:Get9BoxUnlockMaxIndex()
  if LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_4) == 1 then
    return 12
  end
  if LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_3) == 1 then
    return 9
  end
  if LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALCOMPETE_ACT_UNLOCK_BOX_2) == 1 then
    return 6
  end
  return 3
end

function AllianceCompeteDataManager:Check9BoxUnlock(index)
  local maxIndex = self:Get9BoxUnlockMaxIndex()
  return index <= maxIndex
end

function AllianceCompeteDataManager:Check9BoxCanOpen()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityInfo == nil or activityInfo:GetEventInfo() == nil then
    return false
  end
  local unlock = self:Get9BoxUnlockMaxIndex()
  local flagList = activityInfo:GetEventInfo().newRewardFlagList
  if flagList == nil then
    return true
  end
  for i = unlock, 1, -1 do
    local flag = flagList[i]
    if flag == nil or tonumber(flag) ~= i then
      return true
    end
  end
  return false
end

function AllianceCompeteDataManager:IsAll9BoxRewardReceived()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityInfo == nil or activityInfo:GetEventInfo() == nil or activityInfo.GetBoxReceiveState == nil then
    return false
  end
  local eventInfo = activityInfo:GetEventInfo()
  local boxCount = eventInfo.targetList and #eventInfo.targetList or 0
  if boxCount <= 0 then
    return false
  end
  for i = boxCount, 1, -1 do
    if activityInfo:GetBoxReceiveState(i) ~= 3 then
      return false
    end
  end
  return true
end

function AllianceCompeteDataManager:GetMainUITip()
  if self:Check9BoxCanOpen() then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    local heroEventMeta = LocalController:instance():getLine(TableName.HeroEvent, activityInfo:GetEventInfo().eventId)
    if heroEventMeta then
      return heroEventMeta.score_way_mainUI_tips_icon, heroEventMeta.score_way_mainUI_tips_name
    end
  end
end

function AllianceCompeteDataManager:MoveCity(targetPointIndex)
  local serverId = LuaEntry.Player:GetCurServerId()
  MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity, serverId, targetPointIndex, true)
end

function AllianceCompeteDataManager:MoveCrossServerHandle(message)
  local errCode = message.errorCode
  local jumpToParam = CrossServerUtil.GetLastJumpToParam()
  if errCode == nil then
    if jumpToParam and jumpToParam.cmd == MsgDefines.AllianceMoveCity and jumpToParam.free then
      UIUtil.ShowTipsId("alliance_relocation_tips01")
    end
    local ip = message.serverInfo.ip
    local ws_ip = message.serverInfo.ws_ip
    local connectionType = CS.NetConnectionType.CUSTOM_TCP
    local port = tonumber(message.serverInfo.port)
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_SERVER_WS_CONNECTION) and ws_ip ~= nil and ws_ip ~= "" then
      ip = ws_ip
      connectionType = CS.NetConnectionType.CUSTOM_WEBSOCKET
      port = 80
    end
    CS.AccountCredentialManager.SetServerNetInfo(ip, port, message.serverInfo.zone, connectionType)
    Logger.LogInfo("[AT]SetGUID_MovCrossSvr:" .. tostring(LuaEntry.Player.uid))
    CrossServerUtil.SetLastJumpToParam(nil)
    LuaEntry.Player:SetCrossServerId(-1)
    CS.GameEntry.NetworkCross:RemoveConnect()
    TimerManager:GetInstance():DelayInvoke(function()
      CS.CrossServerUtil.SilentLogin()
    end, 0.3)
    Logger.LogInfo("cross server info 1 " .. ip .. port .. message.serverInfo.zone .. tostring(connectionType))
    EventManager:GetInstance():Broadcast(EventId.MoveCitySuccess)
  else
    EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Close)
    local tryMoveTo
    if jumpToParam and jumpToParam.cmd == MsgDefines.AllianceMoveCity then
      tryMoveTo = tostring(jumpToParam.serverId)
    elseif jumpToParam then
      local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
      tryMoveTo = tostring(jumpToParam.serverId)
      CrossServerUtil.ShowMoveCityModel(pointId, jumpToParam, jumpToParam.serverId)
    else
      tryMoveTo = CrossServerUtil.GetLastMoveCityServer() or "???"
      DataCenter.GuideManager:SetNoShowUIMain(false)
    end
    Logger.LogInfo(string.format("CrossServer.Fail (%s, %s)", errCode, tryMoveTo))
    if not CrossServerUtil.IsCrossMoveCD(true, tryMoveTo) then
      if errCode == SeverErrorCode or errCode == 302191 or errCode == "302191" then
        UIUtil.ShowTipsId(120447)
      else
        UIUtil.ShowTipsId(errCode)
      end
    end
  end
end

function AllianceCompeteDataManager:PushLeaveCrossServerHandle(message)
  local errCode = message.errorCode
  if errCode == nil then
    if message.migrateType == 3 then
      EventManager:GetInstance():Broadcast(EventId.ActMigrationMsg, 0)
    end
    local ip = message.serverInfo.ip
    local ws_ip = message.serverInfo.ws_ip
    local connectionType = CS.NetConnectionType.CUSTOM_TCP
    local port = tonumber(message.serverInfo.port)
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_SERVER_WS_CONNECTION) and ws_ip ~= nil and ws_ip ~= "" then
      ip = ws_ip
      connectionType = CS.NetConnectionType.CUSTOM_WEBSOCKET
      port = 80
    end
    CS.AccountCredentialManager.SetServerNetInfo(ip, port, message.serverInfo.zone, connectionType)
    Logger.LogInfo("[AT]SetGUID_PushLeaveCrossSvr:" .. tostring(LuaEntry.Player.uid))
    CrossServerUtil.SetLastJumpToParam(nil)
    TimerManager:GetInstance():DelayInvoke(function()
      CS.CrossServerUtil.SilentLogin()
    end, 0.3)
    Logger.LogInfo("cross server info 2 " .. ip .. port .. message.serverInfo.zone .. tostring(connectionType))
  else
    UIUtil.ShowTipsId(errCode)
  end
end

function AllianceCompeteDataManager:CanOpenAllyDuelUI()
  local open = self:CheckIfAllianceCompeteOpen()
  return open
end

function AllianceCompeteDataManager:TryOpenAllyDuelUI()
  if self:CanOpenAllyDuelUI() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuel, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    return true
  end
  return false
end

local SETTLE_DAY = 7
local SETTLE_HOUR = 4

function AllianceCompeteDataManager:IsSettleStage()
  local now = UITimeManager:GetInstance():GetServerTime()
  local weekIndex = UITimeManager:GetInstance():GetWeekdayIndex(now)
  if weekIndex ~= SETTLE_DAY then
    return false
  end
  local todayZero = UITimeManager:GetInstance():TodayZero()
  local todayFour = todayZero + SETTLE_HOUR * 3600000
  if now > todayFour then
    return false
  end
  return todayFour
end

function AllianceCompeteDataManager:GetScienceTip()
  if not self.scienceTips then
    self.scienceTips = {}
    LocalController:instance():visitTable(TableName.AllyDuelTips, function(id, lineData)
      local template = {}
      template.condition = lineData:getIntValue("condition")
      template.priority = lineData:getIntValue("priority")
      template.desc = lineData:getValue("desc")
      template.icon = lineData:getValue("icon")
      local jump = lineData:getValue("jump")
      jump = string.split(jump, ",")
      template.jumpType = tonumber(jump[1])
      template.jumpValue = tonumber(jump[2])
      table.insert(self.scienceTips, template)
    end)
    table.sort(self.scienceTips, function(a, b)
      return a.priority > b.priority
    end)
  end
  for _, v in ipairs(self.scienceTips) do
    local condition = v.condition
    if condition <= 0 then
      local tabState = DataCenter.ScienceTemplateManager:GetTabState(9)
      if tabState ~= ScienceTabState.UnLock then
        return v
      end
    elseif not DataCenter.ScienceManager:HasScienceById(condition) then
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplateById(condition)
      if template:IsTimeConditionValid() then
        return v
      end
    end
  end
end

function AllianceCompeteDataManager:IsShowRankBtn()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local weekday = UITimeManager:GetInstance():GetWeekdayIndex(now)
  if weekday ~= 7 then
    return self:HaveOpponent()
  else
    local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
    if duelInfo then
      if duelInfo.rankType == SegmentType.Silver then
        return true, 10
      elseif duelInfo.rankType == SegmentType.Gold then
        return true, 20
      elseif duelInfo.rankType == SegmentType.Diamond then
        return true
      end
    end
  end
  return false
end

function AllianceCompeteDataManager:FetchAllianceBattlePoint()
  if SeasonUtil.GetSourceSeasonType() == SeasonMapType.NineNation then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceBattlePoint)
  else
    SFSNetwork.SendMessage(MsgDefines.CrossGetAlliancePoint)
  end
  SFSNetwork.SendMessage(MsgDefines.GetAllianceCenterPoint)
end

function AllianceCompeteDataManager:HandleGetAllianceBattlePointMessage(pointArr)
  for _, v in pairs(pointArr) do
    if v.markType == MarkType.Alliance_OtherServerRally then
      self.goPoint2 = v
    elseif v.markType == MarkType.Alliance_rally then
      self.goPoint = v
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllyDuelRecommendPointRefresh)
end

local function HandleRecommendAttackPointMessage(self, serverId, pointId)
  self.goPoint = {server = serverId, pointId = pointId}
  if serverId == self:GetFightServerId() then
    self.recommendPoint = pointId
  end
  EventManager:GetInstance():Broadcast(EventId.AllyDuelRecommendPointRefresh)
end

local function HandleRecommendBackPointMessage(self, pointId)
  self.recommendPoint = pointId
end

function AllianceCompeteDataManager:GetPoint()
  return self.goPoint, self.goPoint2
end

local function GetRecommendPoint(self)
  return self.recommendPoint
end

local function IsExistTargetScoreTypeInCurAllianceCompete(self, scoreSourceType)
  if not scoreSourceType then
    return false
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityInfo == nil then
    return false
  end
  local eventInfo = activityInfo:GetEventInfo()
  if not eventInfo or not eventInfo.scoreIdList then
    return false
  end
  local scoreIdList = eventInfo.scoreIdList
  local isContainTargetType = false
  for _, v in pairs(scoreIdList) do
    local scoreId = v
    local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
    if cfg and cfg.type == scoreSourceType then
      isContainTargetType = true
      break
    end
  end
  return isContainTargetType
end

local function IsCurScoreArriveMaxUnlockBox(self)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityInfo == nil then
    return false
  end
  local eventInfo = activityInfo:GetEventInfo()
  if eventInfo == nil or eventInfo.target == nil then
    return false
  end
  local curUnlockBoxIndex = self:Get9BoxUnlockMaxIndex()
  local scoreInfoArr = string.split(eventInfo.target, "|")
  local curMaxUnlockScore = scoreInfoArr[curUnlockBoxIndex]
  if not curMaxUnlockScore or not eventInfo.curScore then
    return false
  end
  return eventInfo.curScore >= tonumber(curMaxUnlockScore)
end

function AllianceCompeteDataManager:HaveOpponent()
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if activityData == nil then
    return false
  end
  local eventInfo = activityData:GetEventInfo()
  return eventInfo and eventInfo.vsAllianceList
end

AllianceCompeteDataManager.__init = __init
AllianceCompeteDataManager.__delete = __delete
AllianceCompeteDataManager.RefreshWeekResultVS = RefreshWeekResultVS
AllianceCompeteDataManager.RefreshRankList = RefreshRankList
AllianceCompeteDataManager.FetchRankList = FetchRankList
AllianceCompeteDataManager.GetVSAllianceList = GetVSAllianceList
AllianceCompeteDataManager.GetFinishTime = GetFinishTime
AllianceCompeteDataManager.GetRankList = GetRankList
AllianceCompeteDataManager.RefreshWeeklySummaryMsg = RefreshWeeklySummaryMsg
AllianceCompeteDataManager.GetWeeklySummaryList = GetWeeklySummaryList
AllianceCompeteDataManager.GetWeeklySummaryStartTime = GetWeeklySummaryStartTime
AllianceCompeteDataManager.CheckIfIsInCompete = CheckIfIsInCompete
AllianceCompeteDataManager.GetFightServerId = GetFightServerId
AllianceCompeteDataManager.CheckCanMoveCityToServer = CheckCanMoveCityToServer
AllianceCompeteDataManager.GetCrossServerEndTime = GetCrossServerEndTime
AllianceCompeteDataManager.GetFightAllianceId = GetFightAllianceId
AllianceCompeteDataManager.UpdateHeroEventInfo = UpdateHeroEventInfo
AllianceCompeteDataManager.GetAlCompeteteTotalRedCount = GetAlCompeteteTotalRedCount
AllianceCompeteDataManager.GetAlCompeteActivityRedCount = GetAlCompeteActivityRedCount
AllianceCompeteDataManager.CacheOpeningTabIndex = CacheOpeningTabIndex
AllianceCompeteDataManager.GetDefaultOpenTabIndex = GetDefaultOpenTabIndex
AllianceCompeteDataManager.RequestFightServerAllianceCity = RequestFightServerAllianceCity
AllianceCompeteDataManager.GetPersonalRank = GetPersonalRank
AllianceCompeteDataManager.GetExtraActivityList = GetExtraActivityList
AllianceCompeteDataManager.HandleRecommendAttackPointMessage = HandleRecommendAttackPointMessage
AllianceCompeteDataManager.HandleRecommendBackPointMessage = HandleRecommendBackPointMessage
AllianceCompeteDataManager.GetRecommendPoint = GetRecommendPoint
AllianceCompeteDataManager.IsExistTargetScoreTypeInCurAllianceCompete = IsExistTargetScoreTypeInCurAllianceCompete
AllianceCompeteDataManager.IsCurScoreArriveMaxUnlockBox = IsCurScoreArriveMaxUnlockBox
return AllianceCompeteDataManager
