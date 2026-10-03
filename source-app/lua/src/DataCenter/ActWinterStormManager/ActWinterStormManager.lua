local ActWinterStormManager = BaseClass("ActWinterStormManager", BattlefieldManagerBase)
local ActWinterStormInfoData = require("DataCenter.ActWinterStormManager.ActWinterStormInfoData")
local ActWinterStormLogData = require("DataCenter.ActWinterStormManager.ActWinterStormLogData")
local ActWinterStormMatchPushData = require("DataCenter.ActWinterStormManager.ActWinterStormMatchPushData")
local ActWinterStormResultData = require("DataCenter.ActWinterStormManager.ActWinterStormResultData")
local ActWinterMainTips = "ActWinterMainTips_"

function ActWinterStormManager:OnInit()
  self.bfType = BattleFieldType.WinterStorm
  self:ResetData()
  self:AddListener()
end

function ActWinterStormManager:OnDelete()
  self:ResetData()
  self:RemoveListener()
end

function ActWinterStormManager:ResetData()
  self.actInfo = nil
  self.logInfo = {}
  self.lastReqLogTime = nil
  self.matchInfo = {}
  self.matchStartTime = 0
  self.matchPushInfo = nil
  self.resultInfo = nil
  self.rewardInfo = nil
  self.achievementDic = {}
  self.rewardTemplates = nil
  self.templatePingList = nil
end

function ActWinterStormManager:GetActInfo()
  return self.actInfo
end

function ActWinterStormManager:AddListener()
  if self.__onApplicationPause == nil then
    function self.__onApplicationPause(isOn)
      self:OnApplicationPause(isOn)
    end
    
    EventManager:GetInstance():AddListener(EventId.APP_APPLICATION_PAUSE, self.__onApplicationPause)
  end
end

function ActWinterStormManager:RemoveListener()
  if self.__onApplicationPause ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.APP_APPLICATION_PAUSE, self.__onApplicationPause)
  end
  self.__onApplicationPause = nil
end

function ActWinterStormManager:OnApplicationPause(isOn)
  if isOn then
    return
  end
  if self.matchStartTime > 0 then
    self:ReqActInfo()
  end
end

function ActWinterStormManager:HandleGetInfo(message)
  if message == nil then
    return
  end
  local mr = self:GetMarchResult()
  local battleEndTime = mr ~= nil and mr.battleEndTime or 0
  local oneData = ActWinterStormInfoData.New()
  oneData:ParseData(message)
  self.actInfo = oneData
  if oneData.state == 1 then
    if self.matchStartTime == 0 then
      self.matchStartTime = UITimeManager:GetInstance():GetServerSeconds()
    end
  else
    if 0 < self.matchStartTime then
      self.matchStartTime = 0
    end
    if self.state == 2 and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWinterStormMatching) then
      self:SendMatchReady(false)
    end
  end
  local mr2 = self:GetMarchResult()
  local battleEndTime2 = mr2 ~= nil and mr2.battleEndTime or 0
  if battleEndTime2 == 0 and 0 < battleEndTime then
    self:SendResult()
  end
  self:ReqRewardInfo()
end

function ActWinterStormManager:CheckBattleStart()
  return self:BattleOpenCheck(false)
end

function ActWinterStormManager:BattleOpenCheck(bShowTip)
  local mr = self:GetMarchResult()
  if mr ~= nil then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    if mr.battleBeginTime > 0 and curSec >= mr.battleBeginTime then
      return true
    end
  end
  if bShowTip then
    UIUtil.ShowTipsId("winter_battlefield_tips1007")
  end
  return false
end

function ActWinterStormManager:GetMarchResult()
  return self.actInfo ~= nil and self.actInfo.marchResult or nil
end

function ActWinterStormManager:GetInBattleWorldLeftTime()
  local mr = self:GetMarchResult()
  if mr ~= nil then
    local endTime = mr.battleEndTime
    if endTime ~= nil and 0 < endTime then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local remainTime = endTime - curTime
      if 0 < remainTime then
        return remainTime
      end
    end
  end
  return 0
end

function ActWinterStormManager:GetMySide()
  local mr = self:GetMarchResult()
  if mr ~= nil then
    return mr:GetMySide()
  end
  return 0
end

function ActWinterStormManager:GetTeamArr(uid)
  local mr = self:GetMarchResult()
  if mr ~= nil then
    return mr:GetTeamArr(uid)
  end
  return nil
end

function ActWinterStormManager:GetWorldCampInWinterStorm(ownerUid)
  local mySide = self:GetMySide()
  local teamArr = self:GetTeamArr(ownerUid)
  if teamArr ~= nil and mySide == teamArr.side then
    return WorldCamp.WsTeammate
  end
  return WorldCamp.WsEnemy
end

function ActWinterStormManager:SendLogInfo(time, num)
  local sendFlag = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastReqLogTime == nil or self.logInfo == nil then
    sendFlag = true
  elseif curTime - self.lastReqLogTime > 10000 then
    sendFlag = true
  end
  if sendFlag then
    SFSNetwork.SendMessage(MsgDefines.WinterStormLog, time or 0, num or 20)
    self.lastReqLogTime = curTime
  else
    self:OpenHistoryView()
  end
end

function ActWinterStormManager:HandleLog(message)
  if message == nil then
    return
  end
  if self.logInfo == nil then
    self.logInfo = {}
  end
  self.logInfo.totalFightCount = message.totalFightCount or 0
  self.logInfo.historyWinCount = message.historyWinCount or 0
  self.logInfo.keepWinCount = message.keepWinCount or 0
  local result = message.result
  if result ~= nil then
    local logs = self.logInfo.logs or {}
    local logTimes = {}
    for _, v in ipairs(logs) do
      logTimes[v.time] = true
    end
    for _, v in ipairs(result) do
      local time = v.battleBeginTime
      if not logTimes[time] then
        local logData = ActWinterStormLogData.New()
        logData:ParseData(v)
        table.insert(logs, logData)
      end
    end
    self.logInfo.logs = logs
  end
  if not table.IsNullOrEmpty(self.logInfo.logs) then
    table.sort(self.logInfo.logs, function(a, b)
      return a.time > b.time
    end)
  end
  self:OpenHistoryView()
end

function ActWinterStormManager:OpenHistoryView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormHistoryS0)
end

function ActWinterStormManager:GetLogInfo()
  return self.logInfo or {}
end

function ActWinterStormManager:SendMatch()
  if LuaEntry.Player:IsInBlackRange(true) or LuaEntry.Player:IsInCityField(true) then
    UIUtil.ShowTipsId(458138)
    return
  end
  self.lastMachClickTime = 0
  SFSNetwork.SendMessage(MsgDefines.WinterStormMatch)
end

function ActWinterStormManager:HandleMatch(message)
  if message == nil then
    return
  end
  self.matchStartTime = UITimeManager:GetInstance():GetServerSeconds()
  self.selfReadyTime = 0
  EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
end

function ActWinterStormManager:GetMatchStartTime()
  return self.matchStartTime
end

function ActWinterStormManager:MatchNewCheckFlag()
  local flag = LuaEntry.DataConfig:CheckSwitch("winter_ready_opt")
  return flag
end

function ActWinterStormManager:CheckInMatchingViewState()
  local msTime = self:CheckInMatchingView(true)
  if 0 < msTime then
    return true
  end
  return false
end

function ActWinterStormManager:CheckInMatchingView(showTips)
  if not self:MatchNewCheckFlag() then
    return 0
  end
  local info = self:GetMatchPushInfo()
  local msTime = info ~= nil and info.timeoutEnd or 0
  if 0 < msTime then
    local remainTime = msTime - UITimeManager:GetInstance():GetServerSeconds()
    if 0 < remainTime then
      if showTips then
        UIUtil.ShowTipsId("winter_s0_tips_15")
      end
      return msTime
    end
  end
  return 0
end

function ActWinterStormManager:CheckMatchingShow()
  local msTime = self:GetMatchStartTime() or 0
  if 0 < msTime then
    return 1, msTime
  end
  msTime = self:CheckInMatchingView()
  if 0 < msTime then
    return 2, msTime
  end
  return 0
end

function ActWinterStormManager:CheckInBattleTime()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return false
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local noticeEndTime = actInfo.noticeEndTime or 0
  if curSec < noticeEndTime then
    return false
  end
  local battleEndTime = actInfo.battleEndTime or 0
  if curSec >= battleEndTime then
    return false
  end
  local MyDate = os.date
  local MyModf = math.modf
  local offSet = MyModf(UITimeManager:GetInstance():GetTimezoneOffset() / 1000)
  local dateCur = MyDate("!*t", curSec + offSet)
  local battleBeginTime = actInfo.battleBeginTime or 0
  local dateBattle = MyDate("!*t", battleBeginTime + offSet)
  local hourTime = 3600
  local dayTime = hourTime * 24
  while dateCur.day > dateBattle.day do
    battleBeginTime = battleBeginTime + dayTime
    dateBattle = MyDate("!*t", battleBeginTime + offSet)
  end
  local k4 = actInfo.battleK4
  local k5 = actInfo.battleK5
  local nextTime
  for i = 1, 3 do
    local time = k4[i]
    if time ~= nil then
      local time1 = battleBeginTime + time * hourTime
      if nextTime == nil and curSec < time1 then
        nextTime = time1
      end
      local time2 = time1 + k5 * hourTime
      if curSec >= time1 and curSec < time2 then
        return true, time2
      end
    end
  end
  return false, nextTime
end

function ActWinterStormManager:SendMatchReady(bReady)
  self.bReady = bReady
  SFSNetwork.SendMessage(MsgDefines.WinterStormMatchReady, bReady)
end

function ActWinterStormManager:HandleMatchReady(message)
  if message == nil then
    return
  end
  local ret = message.ret or 0
  if ret == 1 and self.bReady == true then
    local info = self:GetMatchPushInfo()
    if info ~= nil then
      info:UpdateBReady(LuaEntry.Player:GetUid())
      self.lastMachClickTime = UITimeManager:GetInstance():GetServerSeconds()
      self.selfReadyTime = self.lastMachClickTime
      EventManager:GetInstance():Broadcast(EventId.WinterStormMatchRefresh)
    end
  end
  self.bReady = false
end

function ActWinterStormManager:TryCancelMatch(cType)
  local sendFlag = false
  if self.matchStartTime > 0 then
    sendFlag = true
  else
    local state = self.actInfo ~= nil and self.actInfo.state or 0
    if state == 1 then
      sendFlag = true
    end
  end
  if sendFlag then
    SFSNetwork.SendMessage(MsgDefines.WinterStormMatchCancel, cType)
    UIUtil.ShowTipsId("winter_battlefield_tips1009")
  end
end

function ActWinterStormManager:SendMatchCancel()
  SFSNetwork.SendMessage(MsgDefines.WinterStormMatchCancel, WinterStormCancelType.Default)
end

function ActWinterStormManager:HandleMatchCancel(message)
  if message == nil then
    return
  end
  if message.ret == true then
    self.matchStartTime = 0
    EventManager:GetInstance():Broadcast(EventId.WinterStormMatchRefresh)
  end
end

function ActWinterStormManager:HandleMatchForbid(message)
  if message == nil then
    return
  end
  if message.matchCDTime then
    local actInfo = self:GetActInfo()
    if actInfo then
      actInfo.matchCDTime = message.matchCDTime
    end
    EventManager:GetInstance():Broadcast(EventId.WinterStormMatchRefresh)
  end
end

function ActWinterStormManager:HandleMatchPush(message)
  if message == nil then
    return
  end
  local oneData = ActWinterStormMatchPushData.New()
  oneData:ParseData(message)
  self.matchPushInfo = oneData
  self.matchStartTime = 0
  self.selfReadyTime = 0
  if message ~= nil and message.team ~= nil then
    local mr = self:GetMarchResult()
    if mr ~= nil then
      mr:ParseTeamData(message.team)
    end
  end
  local canOpen = true
  if DataCenter.GuideManager:InGuide() or CS.ApplicationLaunch.Instance.Loading.IsLoading or CS.SceneManager.IsInPVE() then
    canOpen = false
  end
  if canOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormMatching)
  end
  EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
end

function ActWinterStormManager:GetMatchPushInfo()
  return self.matchPushInfo
end

function ActWinterStormManager:GetFakeMatchPushInfo(isReady)
  local teamData = {}
  local readyCount = 0
  for i = 1, 5 do
    local data = {
      head = "",
      server = LuaEntry.Player:GetSelfServerId(),
      uid = LuaEntry.Player:GetUid(),
      name = "dfff1" .. i,
      allianceName = "I69",
      lv = math.random(1, 36),
      title = 0,
      frame = 2,
      b_ready = isReady
    }
    table.insert(teamData, data)
    if isReady then
      readyCount = readyCount + 1
    end
  end
  local tempTeamData = {
    timeoutEnd = UITimeManager:GetInstance():GetServerSeconds() + 120,
    team = teamData,
    readyCnt = readyCount
  }
  self.matchPushInfo = tempTeamData
end

function ActWinterStormManager:HandleEnterPush(message)
  if message == nil then
    return
  end
  local mr = self:GetMarchResult()
  if mr ~= nil then
    if message.battleBeginTime ~= nil then
      mr.battleBeginTime = message.battleBeginTime
    end
    if message.battleEndTime ~= nil then
      mr.battleEndTime = message.battleEndTime
    end
    if message.team ~= nil then
      mr:ParseTeamData(message.team)
    end
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormMatching)
  self.matchPushInfo = nil
  self.matchStartTime = 0
  self.lastMachClickTime = 0
  self:ReqActInfo()
  self:TryEnterBattlefield()
end

function ActWinterStormManager:HandleMatchReadyPush(message)
  if message == nil then
    return
  end
  local info = self:GetMatchPushInfo()
  if info ~= nil then
    info:UpdateReadyInfo(message)
    EventManager:GetInstance():Broadcast(EventId.WinterStormMatchRefresh)
  end
end

function ActWinterStormManager:HandleMatchFailPush(message)
  if message == nil then
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormMatching)
  if message.clear then
    local ret = message.clear or 2
    self.matchPushInfo = nil
    self.matchStartTime = ret == 1 and UITimeManager:GetInstance():GetServerSeconds() or 0
    if ret == 1 then
      UIUtil.ShowTipsId("winter_battlefield_tips1010")
    end
  end
  EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
end

function ActWinterStormManager:SendResult()
  local now = UITimeManager:GetInstance():GetServerTime()
  local last = self.lastSendResultTime or 0
  if 5000 <= now - last then
    SFSNetwork.SendMessage(MsgDefines.WinterStormResult)
    self.lastSendResultTime = now
  end
end

function ActWinterStormManager:HandleResultPush(message)
  if message == nil then
    return
  end
  local oneData = ActWinterStormResultData.New()
  oneData:ParseData(message)
  self.resultInfo = oneData
  local actInfo = self:GetActInfo()
  if actInfo ~= nil then
    actInfo.state = 0
  end
  local mr = self:GetMarchResult()
  if mr then
    if message.team then
      mr:UpdateTeamData(message.team)
    end
    mr.battleEndTime = 0
  end
end

function ActWinterStormManager:GetAchievementTemplate(id)
  local template = self.achievementDic[id]
  if template == nil then
    local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, id)
    if lineData then
      template = {
        id = id,
        achievement_type = lineData:getIntValue("achievement_type"),
        name = lineData:getValue("name"),
        priority = lineData:getIntValue("priority"),
        value = lineData:getIntValue("value"),
        desc = lineData:getValue("desc"),
        short_name = lineData:getValue("short_name"),
        display_interval = lineData:getIntValue("display_interval"),
        min_display_interval = lineData:getIntValue("min_display_interval"),
        icon = lineData:getValue("icon")
      }
      self.achievementDic[id] = template
    end
  end
  return template
end

function ActWinterStormManager:SortAchievement(list)
  table.sort(list, function(a, b)
    local tA = self:GetAchievementTemplate(a)
    local tB = self:GetAchievementTemplate(b)
    local pA = tA ~= nil and tA.priority or 0
    local pB = tB ~= nil and tB.priority or 0
    return pA < pB
  end)
end

function ActWinterStormManager:GetScoreInfo(type, config, param)
  local scoreList = config.scoreList or {}
  local min, max, value = math.huge, 0, 0
  local preAdd = 0
  local achievementDic
  if type == BF_RewardPointType.ACHIEVEMENT then
    achievementDic = {}
    if not table.IsNullOrEmpty(param) then
      for _, id in ipairs(param) do
        achievementDic[id] = true
      end
    end
  end
  for j, scoreId in ipairs(scoreList) do
    local scoreCfg = LocalController:instance():getLine(TableName.Score, scoreId)
    local score = scoreCfg:getIntValue("points")
    if min > score then
      min = score
    end
    if max < score then
      max = score
    end
    if type == BF_RewardPointType.SCORE then
      value = scoreCfg:getIntValue("value")
      if param ~= nil and param >= value then
        preAdd = score
      end
    elseif type == BF_RewardPointType.RANK then
      value = string.string2array_i_oneSep(scoreCfg:getValue("value"), "|")
      if param ~= nil and value ~= nil and param == value[1] then
        preAdd = score
      end
    elseif type == BF_RewardPointType.MVP then
      value = scoreCfg:getIntValue("value")
      if param ~= nil and param == value then
        preAdd = score
      end
    elseif type == BF_RewardPointType.ACHIEVEMENT then
      local typeId = config.typeIds[j]
      if achievementDic[typeId] then
        preAdd = preAdd + score
      end
    end
  end
  return min, max, value, preAdd
end

function ActWinterStormManager:GetResult()
  return self.resultInfo
end

function ActWinterStormManager:CleanResult()
  self.resultInfo = nil
  local mr = self:GetMarchResult()
  if mr ~= nil then
    mr.marchId = 0
  end
end

function ActWinterStormManager:HandleSideScorePush(message)
  if message == nil then
    return
  end
  local info = {}
  info.side = message.side or 0
  info.score = message.score or 0
  info.updateScore = message.updateScore or 0
  if message.uid then
    info.uid = message.uid
  end
  if message.buildingUUID then
    info.buildUUID = message.buildingUUID
    self:UpdateBuildingScore(info.buildUUID, message.buildingScore)
  end
  local battleScore = self.actInfo ~= nil and self.actInfo.battleScore or nil
  if battleScore then
    for side, v in pairs(battleScore) do
      if side == info.side then
        v = info.score
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.WinterStormScoreChange, info)
end

function ActWinterStormManager:GetBuildScore(buildUUID)
  local info = self:GetBuildBestMarch(buildUUID)
  return info ~= nil and info.buildScore or 0
end

function ActWinterStormManager:UpdateBuildingScore(buildUUID, buildScore)
  local info = self:GetBuildBestMarch(buildUUID)
  if info == nil then
    info = {}
    info.buildUUID = buildUUID
  end
  if buildScore then
    info.buildScore = buildScore
  end
  if self.buildPlayerInfos == nil then
    self.buildPlayerInfos = {}
  end
  self.buildPlayerInfos[buildUUID] = info
  local world = CS.SceneManager.World
  local pointInfo = world ~= nil and world:GetPointInfoByUuid(buildUUID) or nil
  if pointInfo ~= nil then
    EventManager:GetInstance():Broadcast(EventId.WinterStormEntityUpdate, pointInfo.pointIndex)
  end
end

function ActWinterStormManager:HandlePlayerBattleEnterPush(message)
  if message == nil then
    return
  end
  if message.effect ~= nil then
    BattleFieldUtil.HandleEffects(message.effect, BattleFieldType.WinterStorm)
  end
  if self.actInfo ~= nil and message.score ~= nil and self.actInfo:HandleBattleScore(message.score) then
    EventManager:GetInstance():Broadcast(EventId.WinterStormScoreChange)
  end
  self.buildPlayerInfos = {}
  local arr = message.buildHp
  if arr ~= nil then
    for _, v in pairs(arr) do
      self:HandleBuildingHpChange(v)
    end
  end
end

function ActWinterStormManager:ReqBattleScore()
  SFSNetwork.SendMessage(MsgDefines.WinterStormBattlePlayer)
end

function ActWinterStormManager:HandleBattlePushPlayer(message)
  if message == nil then
    return
  end
  local ret = message.ret
  if ret == 0 then
    return
  end
  local mr = self:GetMarchResult()
  if mr then
    mr:UpdateTeamData(message.team)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormBattleScore)
end

function ActWinterStormManager:GetGuideList()
  if self.theGuideList == nil then
    self.theGuideList = BattleFieldUtil.GetGuideList(BattleFieldType.WinterStorm)
  end
  return self.theGuideList
end

function ActWinterStormManager:GetRewardList()
  if self.theRewardList ~= nil then
    return self.theRewardList
  end
  local theRewardList = {}
  local tbName = self:GetCfgValue(BattleFieldTableKey.REWARD)
  LocalController:instance():visitTable(tbName, function(id, lineData)
    table.insert(theRewardList, {
      num = lineData:getIntValue("id"),
      type = lineData:getIntValue("type"),
      rewardId = lineData:getIntValue("rewardId"),
      desc = lineData:getValue("desc"),
      condition = lineData:getIntValue("condition"),
      para = lineData:getIntValue("para"),
      limit = lineData:getIntValue("limit")
    })
  end)
  self.theRewardList = theRewardList
  return theRewardList
end

function ActWinterStormManager:IsAllRewardFinish()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return false
  end
  local info = self:GetRewardInfo()
  local curScore = info.score or 0
  local configList = self:GetRewardTemplates()
  for _, v in ipairs(configList) do
    if self:GetBoxState(v, curScore, 0) == 2 then
      return false
    end
  end
  return true
end

function ActWinterStormManager:GetRewardTemplates()
  if self.rewardTemplates == nil then
    local configList = {}
    local tbName = BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.WinterStorm, BattleFieldTableKey.REWARD)
    LocalController:instance():visitTable(tbName, function(id, lineData)
      local info = {
        id = id,
        type = lineData:getIntValue("type"),
        rewardId = lineData:getIntValue("rewardId"),
        score = lineData:getIntValue("para"),
        value = lineData:getIntValue("value"),
        desc = lineData:getValue("desc")
      }
      table.insert(configList, info)
    end)
    table.sort(configList, function(a, b)
      local aSp = self:IsRoundBox(a)
      local bSp = self:IsRoundBox(b)
      if aSp == bSp then
        return a.score < b.score
      else
        return not aSp
      end
    end)
    self.rewardTemplates = configList
  end
  local roundScore = 0
  local lastConfig = self.rewardTemplates[#self.rewardTemplates]
  if self:IsRoundBox(lastConfig) then
    roundScore = lastConfig.score
  end
  return self.rewardTemplates, roundScore
end

function ActWinterStormManager:ReqRewardInfo()
  SFSNetwork.SendMessage(MsgDefines.WinterStormRewardInfo)
end

function ActWinterStormManager:HandleRewardInfo(t)
  local info = {
    score = t.score,
    round = t.number
  }
  local data = {}
  if not table.IsNullOrEmpty(t.data) then
    for _, id in ipairs(t.data) do
      data[id] = true
    end
  end
  info.data = data
  self.rewardInfo = info
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
  EventManager:GetInstance():Broadcast(EventId.WinterStormInfoRefresh)
  EventManager:GetInstance():Broadcast(EventId.WinterStormRewardInfo)
end

function ActWinterStormManager:IsRoundBox(config)
  return config ~= nil and config.type == 2
end

function ActWinterStormManager:GetRound()
  local info = self:GetRewardInfo()
  return info.round or 0
end

function ActWinterStormManager:GetRoundCanGetCnt(curScore)
  local boxesConfig = self:GetRewardTemplates()
  local lConfig = #boxesConfig
  local config = boxesConfig[lConfig]
  local lastConfig = boxesConfig[lConfig - 1]
  local round = self:GetRound()
  local left = math.max(curScore - lastConfig.score - round * config.score, 0)
  local cnt = 0
  local roundMax = LuaEntry.DataConfig:TryGetNum("winter_bf_S0", "k1", 0)
  if round < roundMax then
    cnt = math.min(math.floor(left / config.score), roundMax - round)
  else
    cnt = 0
  end
  return cnt, left
end

function ActWinterStormManager:GetBoxState(config, curScore, fakeAdd)
  if self:IsRoundBox(config) then
    local cnt = self:GetRoundCanGetCnt(curScore)
    if 0 < cnt then
      return 2
    end
  else
    local info = self:GetRewardInfo()
    local sNum = curScore + fakeAdd or 0
    local data = info.data or {}
    local state = data[config.id]
    if state then
      return 3
    end
    if sNum >= config.score then
      return 2
    end
  end
  return 1
end

function ActWinterStormManager:GetRewardInfo()
  return self.rewardInfo or {}
end

function ActWinterStormManager:ReqGetReward(id)
  SFSNetwork.SendMessage(MsgDefines.WinterStormRewardGet, id)
end

function ActWinterStormManager:HandleRewardGet(t)
  if self.rewardInfo then
    if t.id and self.rewardInfo.data then
      self.rewardInfo.data[t.id] = true
    end
    if t.number then
      self.rewardInfo.round = t.number
    end
  end
  if t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
    EventManager:GetInstance():Broadcast(EventId.WinterStormRewardInfo)
  end
end

function ActWinterStormManager:GetClosestPos(target)
  local ret = target
  local findBestPos = false
  local list = CS.SceneManager.World:GetAllDragonPointList()
  local cityList = CS.SceneManager.World:GetAllMainBaseList()
  local TileIndexToWorld = SceneUtils.TileIndexToWorld
  for bestLen = 10, 20 do
    if cityList ~= nil then
      for _, v in pairs(cityList) do
        local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
        if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
          ret = pos
          findBestPos = true
          break
        end
      end
    end
    if not findBestPos and list then
      for _, v in pairs(list) do
        local detailInfo = v.detail
        if detailInfo ~= nil then
          local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
          if bestLen > math.abs(pos.x - target.x) and bestLen > math.abs(pos.z - target.z) then
            ret = pos
            findBestPos = true
            break
          end
        end
      end
    end
    if findBestPos then
      break
    end
  end
  return ret
end

function ActWinterStormManager:GetTotalRedCount()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return 0
  end
  local info = self:GetRewardInfo()
  local curScore = info.score or 0
  local configList = self:GetRewardTemplates()
  local flag = false
  for _, v in ipairs(configList) do
    if self:GetBoxState(v, curScore, 0) == 2 then
      flag = true
      break
    end
  end
  return flag and 1 or 0
end

function ActWinterStormManager:RecordGotoTipStatus()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local strK = ActWinterMainTips .. LuaEntry.Player.uid
  Setting:SetInt(strK, now)
end

function ActWinterStormManager:CheckGotoTipStatus()
  if not RaceEntranceUtil.IsOldEntranceOpen() then
    return nil
  end
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActWinterStorm.Type)
  if activityData == nil then
    return nil
  end
  if table.IsNullOrEmpty(self.actInfo) then
    return nil
  end
  local flag = self:CheckInBattleTime()
  if flag then
    local strK = ActWinterMainTips .. LuaEntry.Player.uid
    local lastTime = Setting:GetInt(strK, 0)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if now - lastTime < 7200 then
      return nil
    end
    return "winter_battlefield_tips1035"
  end
  return nil
end

function ActWinterStormManager:GetBGM(bUp)
  local soundCheckTime = -1
  if bUp == nil then
    local detailInfo = BattleFieldUtil.GetDetailInfoByCfgId(201)
    if detailInfo and detailInfo.State == WinterEntityState.Fixing then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      if curSec < detailInfo.OpenTime then
        soundCheckTime = detailInfo.OpenTime
      else
        bUp = true
      end
    end
  end
  return bUp and 30004 or 30003, soundCheckTime
end

function ActWinterStormManager:UpdateAreaMaterial(mapHandle)
  if mapHandle == nil then
    return
  end
  local mySide = self:GetMySide()
  local myIdx = mySide == 1 and 1 or 0
  for i = 0, 1 do
    local colorIdx = myIdx == i and 1 or 0
    local renderer = mapHandle:GetRenderer(i)
    if IsNotNull(renderer) then
      renderer.sharedMaterial = mapHandle:GetMaterial(colorIdx)
    end
  end
end

local bi_cls = "UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormBattleTopItemNew"
local bi_prefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/WinterStormBattleTopItemNew.prefab"

function ActWinterStormManager:CreateBattleInfoAsync(compCreate, compParent, posY, cb)
  local battle_info
  battle_info = compCreate:LoadComponentAsync(bi_cls, bi_prefab, compParent, function()
    battle_info.gameObject.name = "BattleInfo"
    battle_info:SetOffsetMaxXY(0, 61)
    battle_info:SetOffsetMinXY(0, 0)
    battle_info:SetAnchoredPositionXY(0, posY)
    battle_info:SetLocalScaleXYZ(ResetScale.x, ResetScale.y, ResetScale.z)
    battle_info:ShowEndTime()
    if cb then
      cb()
    end
  end)
  return battle_info
end

local boxList_cls = "UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Component.UIWinterStormBattleTaskBoxList"
local boxList_prefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormBattleTaskBoxList.prefab"

function ActWinterStormManager:CreateTaskBoxListAsync(compCreate, compParent, cb)
  local boxList
  boxList = compCreate:LoadComponentAsync(boxList_cls, boxList_prefab, compParent, cb)
  boxList:SetName("BoxList")
  return boxList
end

local taskList_cls = "UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Component.UIWinterStormTaskS0List"
local taskList_prefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormTaskS0List.prefab"

function ActWinterStormManager:CreateTaskListAsync(compCreate, compParent, cb)
  local taskList
  taskList = compCreate:LoadComponentAsync(taskList_cls, taskList_prefab, compParent, cb)
  taskList:SetName("TaskList")
  return taskList
end

local taskDetailList_cls = "UI.UIActivityCenterTable.Component.ActWinterStorm.Task.Component.UIWinterStormTaskS0DetailList"
local taskDetailList_prefab = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/S0/UIWinterStormTaskS0DetailList.prefab"

function ActWinterStormManager:CreateTaskDetailListAsync(compCreate, compParent, cb)
  local taskList
  taskList = compCreate:LoadComponentAsync(taskDetailList_cls, taskDetailList_prefab, compParent, cb)
  taskList:SetName("TaskDetailList")
  return taskList
end

function ActWinterStormManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine(self.actInfo ~= nil and self.actInfo:Description() or "")
  return sb:ToString()
end

function ActWinterStormManager:GetNextBattleTime()
  local actInfo = self:GetActInfo()
  if actInfo == nil then
    return -1
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local battleEndTime = actInfo.battleEndTime or 0
  if curSec >= battleEndTime then
    return -1
  end
  local MyDate = os.date
  local MyModf = math.modf
  local offSet = MyModf(UITimeManager:GetInstance():GetTimezoneOffset() / 1000)
  local dateCur = MyDate("!*t", curSec + offSet)
  local battleBeginTime = actInfo.battleBeginTime or 0
  local dateBattle = MyDate("!*t", battleBeginTime + offSet)
  local hourTime = 3600
  local dayTime = hourTime * 24
  while dateCur.day > dateBattle.day do
    battleBeginTime = battleBeginTime + dayTime
    dateBattle = MyDate("!*t", battleBeginTime + offSet)
  end
  local k4 = actInfo.battleK4
  for i = 1, 3 do
    local time = k4[i]
    if time ~= nil then
      local time1 = battleBeginTime + time * hourTime
      if curSec < time1 then
        return time1
      end
    end
  end
  return -1
end

function ActWinterStormManager:InitPing()
  if self.templatePingList == nil then
    local curGroup = tonumber(self:GetCfgValue(BattleFieldTableKey.PING))
    self.templatePingList = BattleFieldUtil.InitPingGroup(curGroup)
  end
  return self.templatePingList
end

function ActWinterStormManager:GetPingTemplate(id)
  self:InitPing()
  return self.templatePingList[id]
end

function ActWinterStormManager:ReqWSOrderAdd(cfgId, pid)
  SFSNetwork.SendMessage(MsgDefines.WinterStormOrderAdd, cfgId, pid)
end

function ActWinterStormManager:TestDrop()
  if not CommonUtil.IsDebug() then
    return
  end
  if self.seqJls ~= nil then
    self.seqJls:Kill()
    self.seqJls = nil
  end
  if self.jlsReq ~= nil then
    self.jlsReq:Destroy()
    self.jlsReq = nil
  end
  if self.boxReq ~= nil then
    self.boxReq:Destroy()
    self.boxReq = nil
  end
  self.jlsReq = CS.GameEntry.Resource:InstantiateAsync(UIAssets.LWWorldWinterDrop)
  self.jlsReq:completed("+", function(req)
    if req.isError then
      if self.jlsReq ~= nil then
        self.jlsReq:Destroy()
        self.jlsReq = nil
      end
      return
    end
    local tf = req.gameObject.transform
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
    local startPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    tf:Set_localPosition(startPos.x, startPos.y, startPos.z)
    self:_PlayDrop(tf)
  end)
end

function ActWinterStormManager:_PlayDrop(tf)
  if not CommonUtil.IsDebug() then
    return
  end
  local animation = tf:GetComponentInChildren(typeof(CS.SimpleAnimation))
  local flag = IsNull(animation)
  tf.gameObject:SetActive(not flag)
  if flag then
    return
  end
  local boxPt = animation.transform:Find("To_unity/Root/box02")
  if IsNotNull(boxPt) then
    local config = DataCenter.WinterStormTemplateManager:GetTemplate(100)
    self:_AddBox(boxPt, config:GetModelPath())
  end
  local JlsAct = "Default"
  if animation:IsPlaying(JlsAct) then
    animation:Rewind(JlsAct)
  else
    animation:Play(JlsAct)
  end
  local clipL = animation:GetClipLength(JlsAct)
  self.seqJls = CS.DG.Tweening.DOTween.Sequence()
  self.seqJls:AppendInterval(clipL)
  self.seqJls:OnComplete(function()
    self.seqJls = nil
    tf.gameObject:SetActive(false)
  end)
end

function ActWinterStormManager:_AddBox(boxPt, modelPath)
  if not CommonUtil.IsDebug() then
    return
  end
  self.boxReq = CS.GameEntry.Resource:InstantiateAsync(modelPath)
  self.boxReq:completed("+", function(req)
    if req.isError then
      if self.boxReq ~= nil then
        self.boxReq:Destroy()
        self.boxReq = nil
      end
      return
    end
    local _go = req.gameObject
    local goTrans = _go.transform
    goTrans:SetParent(boxPt)
    goTrans:Set_localPosition(0, 0, 0)
    goTrans:Set_localScale(1, 1, 1)
    goTrans.rotation = Quaternion.Euler(0, -45, 0)
  end)
end

BattleFieldUtil.MergeFunctions(ActWinterStormManager, "DataCenter.ActWinterStormManager.Module.BuildInfo")
BattleFieldUtil.MergeFunctions(ActWinterStormManager, "DataCenter.ActWinterStormManager.Module.EnterBattle")
Implement(ActWinterStormManager, InterfaceConfig.BattlefieldManager, InterfaceConfig.BattlefieldEnterCheck)
return ActWinterStormManager
