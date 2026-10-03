local ZoneWarManager = BaseClass("ZoneWarManager")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ZoneWarTemplate = require("DataCenter.GovernmentManager.ZoneWarTemplate")
local ZoneWarScoreTemplate = require("DataCenter.GovernmentManager.ZoneWarScoreTemplate")

function ZoneWarManager:__init()
  self.configSchedule = nil
  self.roundInfoNow = nil
  self.roundInfoALL = nil
  self.fightInfo = nil
  self.configSchedulePreview = nil
  self.lastFireTime = {}
  self.scheduleDataServerId = nil
  self.ZoneWarScoreConfigDic = {}
  self.CrossKingRoundRank = nil
  self._crossStartTime = nil
  self._roundSettleTime = nil
  self.receivedBattleEnd = false
end

function ZoneWarManager:__delete()
  self.fightInfo = nil
  self.roundInfoALL = nil
  self.roundInfoNow = nil
  self.configSchedule = nil
  self.configSchedulePreview = nil
  self.vsScoreCompare = nil
  self.vsScoreList = nil
  self.vsScoreMVP = nil
  self.receivedBattleEnd = nil
end

function ZoneWarManager:InitZoneWarScoreConfigDic()
  if table.IsNullOrEmpty(self.ZoneWarScoreConfigDic) then
    LocalController:instance():visitTable(TableName.LWZoneWarScore, function(id, lineData)
      local item = ZoneWarScoreTemplate.New()
      item:InitData(lineData)
      table.insert(self.ZoneWarScoreConfigDic, item)
    end)
    table.sort(self.ZoneWarScoreConfigDic, function(a, b)
      return a.id < b.id
    end)
  end
end

function ZoneWarManager:InitData()
  if self.scheduleDataServerId ~= LuaEntry.Player.serverId then
    self.fightInfo = nil
    self.roundInfoALL = nil
    self.roundInfoNow = nil
    self.configSchedule = nil
    self.configSchedulePreview = nil
    self.vsScoreCompare = nil
    self.vsScoreList = nil
    self.vsScoreMVP = nil
    self._crossStartTime = nil
    self._roundSettleTime = nil
  end
  SFSNetwork.SendMessage(MsgDefines.CrossKingSchedule)
end

function ZoneWarManager:GetZoneWarScoreConfigByType(configType)
  self:InitZoneWarScoreConfigDic()
  for i, v in ipairs(self.ZoneWarScoreConfigDic) do
    if (v.type2 == 1 or v.type2 == 2 or v.type2 == 3) and v.type == configType and v.on_off then
      return v
    end
  end
  return nil
end

function ZoneWarManager:GetZoneWarScoreConfigList()
  self:InitZoneWarScoreConfigDic()
  return self.ZoneWarScoreConfigDic
end

function ZoneWarManager:GetCrossFightServerInfo()
  if self.roundInfoNow and self.roundInfoNow.curVsRound then
    return self.roundInfoNow.curVsRound[1]
  end
  return nil
end

function ZoneWarManager:GetCrossKingSchedule()
  return self.configSchedule
end

function ZoneWarManager:InitConfigFromServer(cfg, data)
  if cfg then
    local item = ZoneWarTemplate.New()
    item:InitFromServerData(cfg, data)
    return item
  end
  return nil
end

function ZoneWarManager:SetCrossKingSchedule(data)
  self.isCampBattle = nil
  if data and data.startTime and data.endTime and data.cfg then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < toInt(data.startTime) then
      self.scheduleDataServerId = LuaEntry.Player.serverId
      self.configSchedulePreview = data
      data.configNow = self:InitConfigFromServer(data.cfg, data)
      return
    end
  end
  if data and data.startTime and data.endTime and data.crossStartTime and data.curRound and data.initServerGroup then
    self.configSchedule = data
    self.scheduleDataServerId = LuaEntry.Player.serverId
    self.configSchedulePreview = nil
    self.receivedBattleEnd = false
    self.server_ids = data.server_ids or "???"
    data.configNow = self:InitConfigFromServer(data.cfg, data)
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoALL)
    SFSNetwork.SendMessage(MsgDefines.CrossKingRoundInfoNow)
    SFSNetwork.SendMessage(MsgDefines.CrossKingFightInfo)
    SFSNetwork.SendMessage(MsgDefines.CrossKingPersonScoreRank)
    EventManager:GetInstance():Broadcast(EventId.CrossKingScheduleRefresh)
    EventManager:GetInstance():BroadcastDeferred(EventId.OnPackageInfoUpdated)
    if data.curRound == 1 then
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CrossKingActivity, true)
    end
    if data.configNow and data.configNow:IsBattleMember(LuaEntry.Player:GetSourceServerId()) then
      Setting:SetPrivateString("configSchedule.crossStartTime", tostring(data.crossStartTime or 0))
      Setting:SetPrivateString("configSchedule.roundSettleTime", tostring(data.roundSettleTime or 0))
    end
    Setting:SetPrivateString("configSchedule.startTime", tostring(data.startTime or 0))
    Setting:SetPrivateString("configSchedule.endTime", tostring(data.endTime or 0))
  elseif data and data.startTime and data.endTime and data.cfg then
    self.scheduleDataServerId = LuaEntry.Player.serverId
    self.configSchedulePreview = data
    data.configNow = self:InitConfigFromServer(data.cfg, data)
  end
  if data.campRankList then
    self:ParseVsRoundData(data.curVsRound, true)
    DataCenter.CampWarManager:InitData(data)
  end
  if data and data.curVsRound and data.serverInfo then
    self:SetCrossKingRoundInfoNow({
      curVsRound = data.curVsRound,
      serverInfo = data.serverInfo
    })
  end
end

function ZoneWarManager:IsOver()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.configSchedule == nil or self.configSchedule.endTime and now >= self.configSchedule.endTime then
    return true
  end
  local startTime = toInt(Setting:GetPrivateString("configSchedule.startTime", 0))
  local endTime = toInt(Setting:GetPrivateString("configSchedule.endTime", 0))
  if now < startTime or now > endTime then
    return true
  end
  return false
end

function ZoneWarManager:IsDefenceServer(serverId)
  if self.roundInfoALL and self.roundInfoALL.allRoundInfo then
    local score = -1
    local scoreVS = -1
    local vsServerId = 0
    local curRound = self.roundInfoALL.curRound
    for _, v in ipairs(self.roundInfoALL.allRoundInfo) do
      if v.scoreSettled == 1 and v.round == curRound then
        if v.serverId == serverId then
          score = v.score
          vsServerId = v.vsServerId
        elseif v.vsServerId == serverId then
          scoreVS = v.score
        end
      end
    end
    if vsServerId ~= 0 and 0 <= score and 0 <= scoreVS and (score < scoreVS or score == scoreVS and serverId < vsServerId) then
      return true
    end
  end
  return false
end

function ZoneWarManager:GetCrossKingRoundInfoALL()
  return self.roundInfoALL
end

function ZoneWarManager:SetCrossKingRoundInfoALL(data)
  if data and data.curRound and data.allRoundInfo then
    self.roundInfoALL = data
    self:ParseVsRoundData(data.allRoundInfo)
    EventManager:GetInstance():Broadcast(EventId.CrossKingRoundInfoALLRefresh)
  end
end

function ZoneWarManager:GetCrossKingRoundInfoNow()
  return self.roundInfoNow
end

function ZoneWarManager:SetCrossKingRoundInfoNowScore(data)
  if not data then
    return
  end
  if data.vsScoreMVP then
    self.vsScoreMVP = data.vsScoreMVP
  end
  if data.vsScoreCompare then
    self.vsScoreCompare = data.vsScoreCompare
  end
  if not data.page or data.page <= 1 then
    self.vsScoreList = data.vsScoreList
    EventManager:GetInstance():Broadcast(EventId.CrossKingRoundInfoNowRefresh)
  else
    EventManager:GetInstance():Broadcast(EventId.CrossKingRoundInfoNowAdd, data)
  end
end

function ZoneWarManager:SetCrossKingRoundInfoNow(data)
  if data and data.curVsRound ~= nil and data.curVsRound[1] ~= nil then
    self:ParseVsRoundData(data.curVsRound, true)
    local curVsRound = data.curVsRound[1]
    if curVsRound then
      local mySeverId = LuaEntry.Player:GetSourceServerId()
      if curVsRound and (curVsRound.serverId == mySeverId or curVsRound.vsServerId == mySeverId) then
        Setting:SetPrivateString("curVsRound.serverId", tostring(curVsRound.serverId or 0))
        Setting:SetPrivateString("curVsRound.vsServerId", tostring(curVsRound.vsServerId or 0))
      end
    end
    data.now = UITimeManager:GetInstance():GetServerTime()
    self.roundInfoNow = data
    if curVsRound then
      self.roundInfoNow.win = curVsRound.win
    end
    EventManager:GetInstance():Broadcast(EventId.CrossKingRoundInfoNowRefresh)
  end
end

function ZoneWarManager:GetCrossKingFightInfo(fetchWhenNotExist)
  if fetchWhenNotExist and self.fightInfo == nil then
    local lastRequestTime = toInt(self.fightInfoLastRequestTime)
    local now = UITimeManager:GetInstance():GetServerTime()
    if lastRequestTime == nil or 1000 < now - lastRequestTime then
      SFSNetwork.SendMessage(MsgDefines.CrossKingFightInfo)
      self.fightInfoLastRequestTime = now
    end
  end
  return self.fightInfo
end

function ZoneWarManager:SetCrossKingFightInfo(data)
  if data and data.curVsRound ~= nil and data.curVsRound[1] ~= nil then
    self:ParseVsRoundData(data.curVsRound, true)
    self.fightInfo = data
    EventManager:GetInstance():Broadcast(EventId.CrossKingFightInfoRefresh)
  end
end

function ZoneWarManager:GetWeekNum()
  if self.configSchedule then
    return self.configSchedule.curRound
  end
  return 1
end

function ZoneWarManager:GetKingdomBadgesIconPath(serverId)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if serverId == mySourceServerId then
    return DataCenter.GovernmentManager:GetKingdomBadgesIconPath()
  end
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
  local cfgId = 511001
  if kingInfo and kingInfo.badges then
    cfgId = kingInfo.badges.cfgId or 511001
  end
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
  if itemCfg then
    return string.format(LoadPath.ItemPath, itemCfg.icon)
  end
  return "Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png"
end

function ZoneWarManager:IsInData(dataList, serverId)
  if table.IsNullOrEmpty(dataList) then
    return false
  end
  serverId = serverId or LuaEntry.Player:GetSourceServerId()
  local myCamp = self:GetServerCampIndex(serverId)
  if 0 < myCamp then
    for _, v in ipairs(dataList) do
      if v.campId == myCamp then
        return true
      end
    end
  end
  for _, v in ipairs(dataList) do
    if v.serverId == serverId or v.vsServerId == serverId then
      return true
    end
  end
  return false
end

function ZoneWarManager:CanJoinBattle()
  local roundInfo = self:GetCrossKingRoundInfoNow()
  return roundInfo and self:IsInData(roundInfo.curVsRound)
end

function ZoneWarManager:IsBattleMember(serverId)
  serverId = serverId or LuaEntry.Player:GetSourceServerId()
  if self.roundInfoNow and self.roundInfoNow.curVsRound then
    local curVsRound = self.roundInfoNow.curVsRound[1]
    if curVsRound and (curVsRound.serverId == serverId or curVsRound.vsServerId == serverId) then
      return true
    end
  end
  if self.roundInfoALL and self.roundInfoALL.allRoundInfo then
    for _, v in pairs(self.roundInfoALL.allRoundInfo) do
      if v and (v.serverId == serverId or v.vsServerId == serverId) then
        return true
      end
    end
  end
  if self.configSchedule and self.configSchedule.configNow then
    return self.configSchedule.configNow:IsBattleMember(serverId)
  end
  if self.configSchedule and self.configSchedule.initServerGroup and self.configSchedule.initServerGroup.group then
    local groupA = self.configSchedule.initServerGroup.group.a
    local groupB = self.configSchedule.initServerGroup.group.b
    if groupA and groupB then
      if table.indexof(groupA, serverId) ~= false then
        return true
      end
      if table.indexof(groupB, serverId) ~= false then
        return true
      end
    end
  end
  return false
end

function ZoneWarManager:IsBattleServer(serverId)
  if serverId == nil or serverId == 0 then
    return false
  end
  local roundInfo = self:GetCrossKingRoundInfoNow()
  if roundInfo and roundInfo.curVsRound then
    if self:IsInData(roundInfo.curVsRound, serverId) then
      return true
    end
  elseif self.configSchedule then
    if self.configSchedule and self.configSchedule.configNow then
      return self.configSchedule.configNow:IsBattleMember(serverId)
    elseif self.configSchedule and self.configSchedule.cfg then
      local server_ids = self.configSchedule.cfg.server_ids
      if server_ids then
        local group1, group2 = string.match(server_ids, "([^|]+)|([^|]+)")
        if group1 and group2 then
          if table.indexof(string.split(group1, ";"), tostring(serverId)) ~= false then
            return true
          end
          if table.indexof(string.split(group2, ";"), tostring(serverId)) ~= false then
            return true
          end
        end
      end
    end
  end
  return false
end

function ZoneWarManager:GetBattleServer()
  local roundInfo = self:GetCrossKingRoundInfoNow()
  if roundInfo and roundInfo.curVsRound then
    local data = roundInfo.curVsRound[1]
    if data then
      return data.serverId, data.vsServerId
    end
  else
    self:InitData()
  end
  local mySeverId = LuaEntry.Player:GetSourceServerId()
  local serverId = toInt(Setting:GetPrivateString("curVsRound.serverId", nil))
  local vsServerId = toInt(Setting:GetPrivateString("curVsRound.vsServerId", nil))
  if serverId ~= 0 and vsServerId ~= 0 and (serverId == mySeverId or vsServerId == mySeverId) then
    return serverId, vsServerId
  end
  return nil, nil
end

function ZoneWarManager:SortDataByCampOrServer(dataList, mySeverId, sortByCamp)
  if table.IsNullOrEmpty(dataList) then
    return
  end
  mySeverId = mySeverId or LuaEntry.Player:GetSourceServerId()
  local myCamp = self:GetServerCampIndex(mySeverId)
  if 0 < myCamp and dataList[1].campId and 0 < dataList[1].campId then
    if sortByCamp then
      table.sort(dataList, function(a, b)
        return a.campId > b.campId
      end)
    else
      table.sort(dataList, function(a, b)
        return a.campId == myCamp
      end)
    end
    return
  end
  table.sort(dataList, function(a, b)
    return a.serverId == mySeverId
  end)
end

function ZoneWarManager:ParseVsRoundData(curVsRound, sort)
  if not curVsRound then
    return
  end
  for _, v in ipairs(curVsRound) do
    if not v.serverId or v.serverId <= 0 then
      if v.campHeadServer and 0 < v.campHeadServer then
        v.serverId = v.campHeadServer
      elseif v.campId and 0 < v.campId then
        v.serverId = self:GetServerCampLeaderByCamp(v.campId)
      end
    end
  end
  if sort then
    self:SortDataByCampOrServer(curVsRound)
  end
  if curVsRound[1] and curVsRound[2] then
    if 0 >= curVsRound[1].vsServerId then
      curVsRound[1].vsServerId = curVsRound[2].serverId
    end
    if 0 >= curVsRound[2].vsServerId then
      curVsRound[2].vsServerId = curVsRound[1].serverId
    end
  end
end

function ZoneWarManager:ParseVsRound(curVsRound, sortByCamp)
  local mySeverId = self:GetServerCampLeader(LuaEntry.Player:GetSourceServerId())
  self:SortDataByCampOrServer(curVsRound, nil, sortByCamp)
  return mySeverId, curVsRound[1], curVsRound[2]
end

function ZoneWarManager:ParseKillScoreData(killInfo, ownerServerId)
  if table.IsNullOrEmpty(killInfo) then
    return
  end
  if ownerServerId == nil or ownerServerId == 0 then
    ownerServerId = DataCenter.ZoneWarManager:GetOwnerServerIdKingCity()
  end
  if ownerServerId == nil or ownerServerId == 0 then
    return
  end
  if killInfo.hasParse then
    return killInfo[1], killInfo[2]
  end
  killInfo.hasParse = true
  if killInfo[1] == nil then
    local ownerCamp = self:GetServerCampIndex(ownerServerId)
    local attackerServer = self:GetMyEnemyServerNow(ownerServerId)
    killInfo[1] = {
      num = 0,
      serverId = ownerServerId,
      campId = ownerCamp
    }
    killInfo[2] = {
      num = 0,
      serverId = attackerServer,
      campId = self:GetServerCampIndex(attackerServer)
    }
  elseif killInfo[2] == nil then
    local ownerCamp = self:GetServerCampIndex(ownerServerId)
    if killInfo[1].serverId == ownerServerId or 0 < ownerCamp and killInfo[1].campId == ownerCamp then
      local attackerServer = self:GetMyEnemyServerNow(ownerServerId)
      killInfo[2] = {
        num = 0,
        serverId = attackerServer,
        campId = self:GetServerCampIndex(attackerServer)
      }
    else
      killInfo[2] = {
        num = 0,
        serverId = ownerServerId,
        campId = ownerCamp
      }
    end
  end
  self:SortDataByCampOrServer(killInfo)
  return killInfo[1], killInfo[2]
end

function ZoneWarManager:IsBattleDay()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.configSchedule then
    if curTime >= self.configSchedule.crossStartTime and curTime < self.configSchedule.roundSettleTime then
      return true
    else
      DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CrossKingActivity, true)
    end
  end
  local crossStartTime = self._crossStartTime or toInt(Setting:GetPrivateString("configSchedule.crossStartTime", nil))
  local roundSettleTime = self._roundSettleTime or toInt(Setting:GetPrivateString("configSchedule.roundSettleTime", nil))
  if self._crossStartTime == nil then
    self._crossStartTime = crossStartTime
  end
  if self._roundSettleTime == nil then
    self._roundSettleTime = roundSettleTime
  end
  if curTime >= crossStartTime and curTime < roundSettleTime then
    return true
  end
  return false
end

function ZoneWarManager:OnHandleBattleEnd(t)
  self.receivedBattleEnd = true
end

function ZoneWarManager:GetCrossKingBattleStartTime()
  if self.configSchedule then
    return self.configSchedule.crossStartTime
  end
  return UITimeManager:GetInstance():GetServerTime()
end

function ZoneWarManager:CalcOccupyTime(pointNow, addSpeed)
  local totalPoint = SeasonUtil.GetWorldBattleTotalPoint()
  if pointNow >= totalPoint then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = SeasonUtil.GetWorldBattleEndTime()
  if curTime < endTime then
    local remainTime = endTime - curTime
    if addSpeed <= 0 then
      return remainTime
    end
    return math.min(remainTime, 1000 * (totalPoint - pointNow) / addSpeed)
  end
  return 0
end

function ZoneWarManager:GetCrossKingBattleEndTime()
  if self.configSchedule then
    local maxBattleTime = LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k1", 14400)
    local endTime = self.configSchedule.breakThroneProtectTime + maxBattleTime * 1000
    return endTime
  end
  return UITimeManager:GetInstance():GetServerTime()
end

function ZoneWarManager:GetCrossKingBattleFinishTime()
  if self.configSchedule then
    return self.configSchedule.endTime
  end
  return UITimeManager:GetInstance():GetServerTime()
end

function ZoneWarManager:GetServerInfo(severId)
  local roundInfo = self:GetCrossKingRoundInfoNow()
  if roundInfo and roundInfo.serverInfo then
    return roundInfo.serverInfo[tostring(severId)] or {cfgId = 511001}
  end
  return {cfgId = 511001}
end

function ZoneWarManager:GetFightServerNow()
  if self.fightInfo then
    local mySeverId, leftInfo, rightInfo = self:ParseVsRound(self.fightInfo.curVsRound, true)
    if leftInfo.score > rightInfo.score or leftInfo.score == rightInfo.score and leftInfo.serverId > rightInfo.serverId then
      return rightInfo.serverId
    else
      return leftInfo.serverId
    end
  end
  return LuaEntry.Player:GetCurServerId()
end

function ZoneWarManager:GetMyEnemyServerNow(mySeverId)
  mySeverId = self:GetServerCampLeader(mySeverId)
  local roundInfo = self:GetCrossKingRoundInfoNow()
  if roundInfo and roundInfo.curVsRound then
    for _, v in ipairs(roundInfo.curVsRound) do
      if v.serverId == mySeverId then
        return v.vsServerId
      elseif v.vsServerId == mySeverId then
        return v.serverId
      end
    end
  end
  return 0
end

function ZoneWarManager:SetPersonScoreRankRewardPreviewInfo(t)
  if t and t.rewards then
    self.personScoreRankRewardPreview = t.rewards
    EventManager:GetInstance():Broadcast(EventId.CrossKingServerRewardPreviewInfoRefresh)
  end
end

function ZoneWarManager:SetCrossKingServerRewardInfo(t)
  if not table.IsNullOrEmpty(t.kingReward) then
    local campWin = {
      rank = 1,
      kingReward = t.kingReward,
      kingAlReward = t.kingAlReward,
      normalReward = t.winCampReward,
      serverBadges = t.serverBadges
    }
    local campLose = {
      rank = 2,
      normalReward = t.loseCampReward
    }
    self.rankRewardInfo = {campWin, campLose}
  else
    self.rankRewardInfo = t.rankReward
    if self.rankRewardInfo then
      table.sort(self.rankRewardInfo, function(a, b)
        return a.rank < b.rank
      end)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CrossKingServerRewardInfoRefresh)
end

function ZoneWarManager:HasRedPoint()
  if self:HasZoneWinRewardRedPoint() then
    return true
  end
  if self:HasZoneScoreRewardPoint() then
    return true
  end
  return false
end

function ZoneWarManager:HasZoneWinRewardRedPoint()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or fightInfo == nil or fightInfo.user == nil or fightInfo.curVsRound == nil then
    return false
  end
  if fightInfo.user.winServerReward == 1 then
    return false
  end
  local mySeverId, myInfo, targetInfo = DataCenter.ZoneWarManager:ParseVsRound(fightInfo.curVsRound)
  return myInfo ~= nil and myInfo.win == 1
end

function ZoneWarManager:HasZoneScoreRewardPoint()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo()
  local userInfo = fightInfo and fightInfo.user
  if not userInfo then
    return false
  end
  local scoreRewardIndexes = userInfo.scoreRewardIndex
  local score_rewards = userInfo.scoreBox
  local boxCount = score_rewards and #score_rewards
  local score = userInfo.score
  for i = 1, boxCount do
    local boxData = score_rewards[i]
    if boxData and score >= boxData.target and not self:HasZoneScoreRewardOpen(scoreRewardIndexes, i) then
      return true
    end
  end
  return false
end

function ZoneWarManager:HasZoneScoreRewardOpen(scoreRewardIndexes, index)
  if scoreRewardIndexes then
    for _, v in ipairs(scoreRewardIndexes) do
      if v == index - 1 then
        return true
      end
    end
  end
  return false
end

function ZoneWarManager:GetPersonScoreRank()
  if self.rankPersonScore == nil then
    self.rankPersonScore = {}
    local now = UITimeManager:GetInstance():GetServerTime()
    local last_time = toInt(self.lastRequestPersonScore)
    if last_time == 0 or 3000 < now - last_time then
      SFSNetwork.SendMessage(MsgDefines.CrossKingPersonScoreRank)
      self.lastRequestPersonScore = now
    end
  end
  return self.rankPersonScore
end

function ZoneWarManager:SetPersonScoreRank(t)
  self.rankPersonScore = t.ranks
  EventManager:GetInstance():Broadcast(EventId.CrossKingPersonScoreRankRefresh)
end

function ZoneWarManager:UpdateBatteryFireTime(BatteryId, attackTime)
  local old_time = toInt(self.lastFireTime[BatteryId])
  local new_time = toInt(attackTime)
  if old_time < new_time then
    self.lastFireTime[BatteryId] = new_time
  end
end

function ZoneWarManager:GetBatteryLastFireTime(BatteryId, attackTime)
  if attackTime then
    local time1 = toInt(self.lastFireTime[BatteryId] or 0)
    local time2 = toInt(attackTime or 0)
    local time = math.max(time1, time2)
    self.lastFireTime[BatteryId] = time
    return time
  end
  return toInt(self.lastFireTime[BatteryId] or 0)
end

function ZoneWarManager:GetBatteryLeftFireTime(BatteryId, insideTroopCount)
  insideTroopCount = insideTroopCount or 0
  local curServerId = LuaEntry.Player:GetCurServerId()
  local config_key = "tower_zone_war"
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(BatteryId, curServerId)
  if cityTemplate ~= nil and cityTemplate:IsCrossZoneOutpostCanon() then
    config_key = "tower_zone_war_put_out"
  else
    config_key = self:GetTowerZoneWar()
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local towerAttackCd = LuaEntry.DataConfig:TryGetNum(config_key, "k2", 30)
  local towerCdReduceConf = LuaEntry.DataConfig:TryGetStr(config_key, "k6", "5|1|4")
  local towerCdReduceList = string.split(towerCdReduceConf, "|")
  local reduceCount = math.floor(insideTroopCount / tonumber(towerCdReduceList[1] or 5))
  local towerCdReduce = reduceCount * tonumber(towerCdReduceList[2] or 0)
  towerCdReduce = math.min(towerCdReduce, tonumber(towerCdReduceList[3] or 4))
  towerAttackCd = towerAttackCd - towerCdReduce
  local lastTowerAttackTime = DataCenter.ZoneWarManager:GetBatteryLastFireTime(BatteryId)
  return towerAttackCd * 1000 - math.min(curTime - lastTowerAttackTime, towerAttackCd * 1000)
end

local __directionPos = {
  [1] = {
    rotationFrom = Vector3.New(-12, 135, 0),
    rotationTo = Vector3.New(40, 135, 0),
    posFromY = 3.75,
    scale = nil
  },
  [2] = {
    rotationFrom = Vector3.New(-12, -135, 0),
    rotationTo = Vector3.New(40, -135, 0),
    posFromY = 3.75,
    scale = nil
  },
  [3] = {
    rotationFrom = Vector3.New(-12, 45, 0),
    rotationTo = Vector3.New(40, 45, 0),
    posFromY = 3.75,
    scale = nil
  },
  [4] = {
    rotationFrom = Vector3.New(-17, -45, 0),
    rotationTo = Vector3.New(40, -45, 0),
    posFromY = 3.75,
    scale = nil
  },
  [5] = {
    rotationFrom = Vector3.New(-17, -45, 0),
    rotationTo = Vector3.New(40, -45, 0),
    posFromY = 3.75,
    scale = Vector3.New(3, 3, 3)
  },
  [6] = {
    rotationFrom = Vector3.New(-12, 135, 0),
    rotationTo = Vector3.New(40, 135, 0),
    posFromY = 3.75,
    scale = Vector3.New(3, 3, 3)
  },
  [7] = {
    rotationFrom = Vector3.New(-12, 45, 0),
    rotationTo = Vector3.New(40, 45, 0),
    posFromY = 3.75,
    scale = Vector3.New(3, 3, 3)
  }
}
local __directionDic = {
  [1001] = 1,
  [1002] = 2,
  [1003] = 3,
  [1004] = 4,
  [1005] = 5,
  [1006] = 6,
  [1007] = 7,
  [2006] = 1,
  [2007] = 2,
  [2008] = 3,
  [2009] = 4,
  [2010] = 1,
  [2011] = 2,
  [2012] = 3,
  [2013] = 4,
  [2014] = 1,
  [2015] = 2,
  [2016] = 3,
  [2017] = 4,
  [2018] = 1,
  [2019] = 2,
  [2020] = 3,
  [2021] = 4,
  [2022] = 1,
  [2023] = 2,
  [2024] = 3,
  [2025] = 4,
  [2026] = 1,
  [2027] = 2,
  [2028] = 3,
  [2029] = 4,
  [2030] = 1,
  [2031] = 2,
  [2032] = 3,
  [2033] = 4,
  [2034] = 1,
  [2035] = 2,
  [2036] = 3,
  [2037] = 4,
  [2038] = 1,
  [2039] = 2,
  [2040] = 3,
  [2041] = 4
}

function ZoneWarManager:BatteryFire(BatteryId, attackInfo, delayTime)
  local totalDamage = 0
  if attackInfo then
    totalDamage = attackInfo.damage or 0
    self:UpdateBatteryFireTime(BatteryId, attackInfo.attackTime)
  end
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  local serverId = LuaEntry.Player:GetCurServerId()
  local template = DataCenter.AllianceCityTemplateManager:GetTemplate(BatteryId, serverId)
  if not template then
    return
  end
  math.randomseed(SafeLocalOsTime())
  local model = SeasonUtil.GetCanonAnimModel(template.id, nil, template)
  local simAnim
  if model then
    simAnim = model:GetComponent(typeof(CS.SimpleAnimation))
    if simAnim then
      if simAnim:IsPlaying("attack") then
        simAnim:Rewind("attack")
      else
        simAnim:Play("attack")
      end
      simAnim:PlayQueued("idle")
    end
  end
  local kingCityId, kingPointId = SeasonUtil.GetKingCityId(serverId)
  local posTo = SceneUtils.TileIndexToWorld(kingPointId, ForceChangeScene.World, serverId)
  local xr = math.random(1, 7) * math.random(-1, 1) * math.random()
  local yr = math.random(1, 5) * math.random(-1, 1) * math.random()
  posTo.x = posTo.x + xr
  posTo.y = 5
  posTo.z = posTo.z + yr
  posTo = Vector3.New(posTo.x, posTo.y, posTo.z)
  local index = __directionDic[BatteryId]
  local directionInfo = index and __directionPos[index]
  if not directionInfo then
    LogError("ZoneWarManager:BatteryFire no directionInfo for BatteryId:" .. tostring(BatteryId))
    return
  end
  local posFrom = template:GetWorldPos()
  local rotationFrom = directionInfo.rotationFrom
  local rotationTo = directionInfo.rotationTo
  if directionInfo.posFromY and directionInfo.posFromY ~= 0 then
    posFrom.y = directionInfo.posFromY
  end
  self:CreateOneMissile(BatteryId, posFrom, posTo, rotationFrom, rotationTo, totalDamage, delayTime, directionInfo.scale)
end

local MissileBoomPathList = {
  "Assets/_Art_LastWar/Effect/Prefab/Common/D_huangpao_hit.prefab",
  "Assets/_Art_LastWar/Effect/Prefab/Common/D_lanpao_hit_big.prefab",
  "Assets/_Art_LastWar/Effect/Prefab/Common/D_lvpao_hit_big.prefab"
}

local function CreateOneMissileBoom(pos, totalDamage)
  local index = 1 + math.random(1000) % 3
  local MissileBoomPath = MissileBoomPathList[index]
  local request = ResourceManager:InstantiateAsync(MissileBoomPath)
  request:completed("+", function()
    if request.isError then
      return
    end
    if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
      request:Destroy()
      return
    end
    local node = request.gameObject.transform
    node:SetParent(CS.SceneManager.World.DynamicObjNode)
    node:Set_localPosition(pos.x, pos.y, pos.z)
    local seq = CS.DG.Tweening.DOTween.Sequence()
    request.gameObject:SetActive(true)
    seq:AppendInterval(2.4)
    
    function seq.onComplete()
      if not IsNull(request) and type(request.Destroy) == "function" then
        request:Destroy()
      end
    end
  end)
  if totalDamage ~= nil and totalDamage ~= 0 and type(totalDamage) == "number" and 0 < totalDamage then
    local attackDamage = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/canon_damage.prefab")
    attackDamage:completed("+", function()
      if attackDamage.isError then
        return
      end
      if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
        attackDamage:Destroy()
        return
      end
      local scale = 3.3
      local node = attackDamage.gameObject.transform
      local damage_text = node:Find("Icon/damage"):GetComponent(typeof(CS.SuperTextMesh))
      node:SetParent(CS.SceneManager.World.DynamicObjNode)
      node:Set_localScale(scale, scale, scale)
      node:Set_localPosition(pos.x, pos.y, pos.z)
      damage_text.text = "-" .. string.GetFormattedSeparatorNum(totalDamage)
      attackDamage.gameObject:SetActive(true)
      local seq = CS.DG.Tweening.DOTween.Sequence()
      seq:Append(node:DOMove(node.position + Vector3.New(0, 0, 2), 1.68))
      seq:AppendInterval(0.5)
      
      function seq.onComplete()
        if not IsNull(attackDamage) and type(attackDamage.Destroy) == "function" then
          attackDamage:Destroy()
        end
      end
    end)
  end
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)

local function Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function ZoneWarManager:CreateOneMissile(id, startPos, destPos, rotationFrom, rotationTo, totalDamage, delayTime, scale)
  local MissilePath = "Assets/_Art_LastWar/Effect/Prefab/Arms/Aiyinsitan/Eff_Aiyinsitan_daodan_trail.prefab"
  local request = ResourceManager:InstantiateAsync(MissilePath)
  local theScale = scale
  request:completed("+", function()
    if request.isError then
      return
    end
    if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
      request:Destroy()
      return
    end
    local node = request.gameObject.transform
    node:SetParent(CS.SceneManager.World.DynamicObjNode)
    if theScale then
      node:Set_localScale(theScale.x or 1, theScale.y or 1, theScale.z or 1)
    else
      node:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end
    node:Set_localPosition(startPos.x, startPos.y, startPos.z)
    node:Set_localEulerAngles(rotationFrom.x, rotationFrom.y, rotationFrom.z)
    local curveTime = 1.2
    local pointOffset = Vector3.New(math.random(1, 5), math.random(3, 10), math.random(1, 5))
    local controlPos = (startPos + destPos) * 0.5 + pointOffset
    local pathVec = Bezier2Path(startPos, controlPos, destPos)
    local seq = CS.DG.Tweening.DOTween.Sequence()
    request.gameObject:SetActive(true)
    if CS.CommonUtils.IsDebug() and delayTime ~= nil and delayTime ~= 0 then
      seq:AppendInterval(delayTime)
    end
    seq:Append(node:DOPath(pathVec, curveTime)):SetEase(CS.DG.Tweening.Ease.InCubic)
    seq:Join(node:DORotate(rotationTo, curveTime))
    
    function seq.onComplete()
      CreateOneMissileBoom(destPos, totalDamage)
      if not IsNull(request) and type(request.Destroy) == "function" then
        request:Destroy()
      end
    end
  end)
end

function ZoneWarManager:CheckShowMainUIBtn()
  local configSchedule = self.configSchedule
  local mainBuildLV = math.max(toInt(LuaEntry.Player.level), toInt(DataCenter.BuildManager.MainLv), 0)
  if configSchedule == nil or configSchedule.needMainCityLevel ~= nil and mainBuildLV < configSchedule.needMainCityLevel then
    return false
  end
  return not self:IsOver() and self:IsBattleMember()
end

function ZoneWarManager:GetOwnerServerIdKingCity()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
  local pointInfo = CS.SceneManager.World:GetPointInfoWithServer(kingCityPosIndex, curServerId)
  local ownerServerIdKingCity = 0
  local ownerAllianceIdKingCity = ""
  if pointInfo ~= nil then
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if allianceCityPointInfo ~= nil and (allianceCityPointInfo.state == AllianceCityState.SERVER_BUILD_THRONE or allianceCityPointInfo.state == AllianceCityState.SERVER_OCCUPIED) then
      ownerServerIdKingCity = allianceCityPointInfo.serverId or 0
      ownerAllianceIdKingCity = allianceCityPointInfo.allianceId or ""
    end
  else
    local cityData = DataCenter.WorldPointDetailManager:GetAllianceCityData(kingCityId)
    if cityData and cityData.latestOccupy then
      ownerServerIdKingCity = cityData.latestOccupy.serverId or 0
      ownerAllianceIdKingCity = cityData.latestOccupy.allianceId or ""
    end
  end
  if ownerServerIdKingCity == 0 then
    local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(curServerId)
    if currentData then
      ownerServerIdKingCity = currentData.serverId or 0
      ownerAllianceIdKingCity = currentData.allianceId or ""
    end
  end
  return ownerServerIdKingCity, ownerAllianceIdKingCity
end

function ZoneWarManager:GetTowerZoneWar()
  if SeasonUtil.IsInSeasonNineNationMode() then
    return "tower_zone_war_s5"
  end
  return SeasonUtil.IsInSeasonDarknessMode() and "tower_zone_war_s4" or "tower_zone_war"
end

function ZoneWarManager:GetTowerSpeedAdd()
  return LuaEntry.DataConfig:TryGetNum(DataCenter.ZoneWarManager:GetTowerZoneWar(), "k4", 25)
end

function ZoneWarManager:SetCrossKingRoundRank(rankType, ls)
  if not self.CrossKingRoundRank then
    self.CrossKingRoundRank = {}
  end
  self.CrossKingRoundRank[rankType] = ls
end

function ZoneWarManager:GetCrossKingRoundRank(rankType)
  return self.CrossKingRoundRank and self.CrossKingRoundRank[rankType] or {}
end

function ZoneWarManager:GetOccupyHistoryList(uuid)
  if self.occupyHistory then
    return self.occupyHistory[uuid] or self.occupyHistory[1]
  end
end

function ZoneWarManager:SetCityOccupyHistoryList(ls, uuid)
  if not self.occupyHistory then
    self.occupyHistory = {}
  end
  uuid = uuid or 1
  local list = {}
  for i, v in ipairs(ls) do
    local avatar = v.avatar
    local data = BasePlayerInfo.New()
    data:ParseData(avatar)
    data.time = v.time
    list[i] = data
  end
  self.occupyHistory[uuid] = list
  EventManager:GetInstance():Broadcast(EventId.CrossKingOccupyHistoryListRefresh, uuid)
end

function ZoneWarManager:GetVsScoreSumList(roundInfo, leftInfo, rightInfo)
  local vsScoreCompare = roundInfo.vsScoreCompare or DataCenter.ZoneWarManager.vsScoreCompare or {}
  for i, v in ipairs(vsScoreCompare) do
    local leftScoreInfo, rightScoreInfo
    for j, vv in ipairs(v.vs) do
      if vv.serverId and vv.serverId > 0 and self:IsAlly(vv.serverId, leftInfo.serverId) or vv.campId and 0 < vv.campId and vv.campId == leftInfo.campId then
        leftScoreInfo = vv
      else
        rightScoreInfo = vv
      end
    end
    v.vs[1] = leftScoreInfo or {
      serverId = leftInfo.serverId,
      score = 0,
      campId = leftInfo.campId
    }
    v.vs[2] = rightScoreInfo or {
      serverId = rightInfo.serverId,
      score = 0,
      campId = rightInfo.campId
    }
  end
  return vsScoreCompare
end

function ZoneWarManager:TryShowThumbUp(userInfo, key, title)
  if not userInfo then
    return false
  end
  if userInfo.uid == LuaEntry.Player.uid then
    local data = UIUtil.GetPlayerInfoShowByUid(userInfo.uid)
    if data.isSelf and data.thumbsUpCountDiff > 0 and table.count(data.ThumbsUpPlayerList) ~= 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerThumbsUpGlory, {anim = true}, data)
    end
    return false
  end
  if UIUtil.GetTodayActiveCount(string.format("%s_%s_%s", key, LuaEntry.Player.uid, userInfo.uid), true) >= 1 then
    return false
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIServerBattleGlory, {anim = true}, userInfo, title)
  return true
end

local grayBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg01.png"
local blueBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png"
local redBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png"

function ZoneWarManager:SetServerInfo(server_bg, serverText, serverId, status)
  serverText:SetText(string.format("#%s", serverId))
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  if seasonInfo and seasonInfo.campInfo and seasonInfo:GetServerSubdivisionType(false) == SeasonMapType.NineNationRainforest then
    local campId = seasonInfo:GetCampIdByServerId(serverId)
    if campId ~= nil and campId ~= 0 then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      if serverId == mySourceServerId then
        serverText:SetColorHex("#5EF085")
      else
        serverText:SetColorHex("#FFFFFF")
      end
      if campId == 1 then
        server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_fuwuqibg01.png")
      elseif campId == 2 then
        server_bg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_fuwuqibg02.png")
      else
        server_bg:LoadSprite(grayBg)
      end
      return
    end
  end
  if status == 0 then
    serverText:SetColorRGBA(1, 1, 1, 1)
    server_bg:LoadSprite(grayBg)
  elseif status == 2 then
    serverText:SetColorRGBA(0, 0.9647058823529412, 1, 1)
    server_bg:LoadSprite(blueBg)
  elseif status == 1 then
    serverText:SetColorRGBA(1, 0.5490196078431373, 0.4745098039215686, 1)
    server_bg:LoadSprite(redBg)
  else
    serverText:SetColorRGBA(1, 1, 1, 1)
    server_bg:LoadSprite(grayBg)
  end
end

function ZoneWarManager:GetDefenderServerId()
  local fightInfo = self:GetCrossKingFightInfo()
  local fightInfoA = fightInfo and fightInfo.curVsRound[1] or {score = 0, serverId = 0}
  local fightInfoB = fightInfo and fightInfo.curVsRound[2] or {score = 0, serverId = 0}
  if fightInfoB.score > fightInfoA.score or fightInfoB.score == fightInfoA.score and fightInfoB.serverId > fightInfoA.serverId then
    return fightInfoA.serverId
  else
    return fightInfoB.serverId
  end
end

function ZoneWarManager:IsCampBattle()
  if self.isCampBattle == nil then
    self.isCampBattle = self.configSchedule and self.configSchedule.cfg and toInt(self.configSchedule.cfg.type) == ServerBattleType.VSCamp
  end
  return self.isCampBattle
end

function ZoneWarManager:IsAlly(serverId, mySeverId)
  return self:GetCampRelation(serverId, mySeverId) == WorldCamp.Ally
end

function ZoneWarManager:GetCampRelation(serverId, mySeverId)
  mySeverId = mySeverId or LuaEntry.Player:GetSourceServerId()
  if mySeverId == serverId then
    return WorldCamp.Ally
  end
  if not self:IsCampBattle() then
    return WorldCamp.Enemy
  end
  local myCamp = self:GetServerCampIndex(mySeverId)
  local targetCamp = self:GetServerCampIndex(serverId)
  if myCamp == 0 or targetCamp == 0 then
    return WorldCamp.Neutral
  end
  if myCamp == targetCamp then
    return WorldCamp.Ally
  end
  return WorldCamp.Enemy
end

function ZoneWarManager:GetServerCampIndex(serverId)
  serverId = serverId or 0
  if not self:IsCampBattle() then
    return 0
  end
  local group = self.configSchedule and self.configSchedule.initServerGroup and self.configSchedule.initServerGroup.group
  if not (group and group.a) or not group.b then
    return 0
  end
  for i, v in ipairs(group.a) do
    if v == serverId then
      return SeasonFactionType.Rebels
    end
  end
  for i, v in ipairs(group.b) do
    if v == serverId then
      return SeasonFactionType.Gendarmerie
    end
  end
  return 0
end

function ZoneWarManager:GetServerCampLeaderByCamp(campId)
  if campId and 0 < campId then
    local group = self.configSchedule and self.configSchedule.initServerGroup and self.configSchedule.initServerGroup.group
    if not (group and group.a) or not group.b then
      return 0
    end
    if campId == SeasonFactionType.Rebels then
      return group.a[1] or 0
    elseif campId == SeasonFactionType.Gendarmerie then
      return group.b[1] or 0
    end
  end
  return 0
end

function ZoneWarManager:GetServerCampLeader(serverId)
  local campId = self:GetServerCampIndex(serverId)
  local leaderId = self:GetServerCampLeaderByCamp(campId)
  if 0 < leaderId then
    return leaderId
  end
  return serverId
end

function ZoneWarManager:GetCampIcon(serverId, campId)
  serverId = serverId or 0
  if not campId or campId <= 0 then
    campId = self:GetServerCampIndex(serverId)
  end
  if 0 < campId then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.Snow then
      local conf = self.configSchedule and self.configSchedule.cfg
      if conf then
        if campId == SeasonFactionType.Rebels then
          return conf.faction_a_icon, campId
        elseif campId == SeasonFactionType.Gendarmerie then
          return conf.faction_b_icon, campId
        end
      end
    elseif seasonType == SeasonMapType.Mummy then
      if campId == SeasonFactionType.Rebels then
        return "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/ljq_s3_zhenying_1_mid.png", campId
      elseif campId == SeasonFactionType.Gendarmerie then
        return "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/ljq_s3_zhenying_2_mid.png", campId
      end
    elseif seasonType == SeasonMapType.Darkness then
      if campId == SeasonFactionType.Rebels then
        return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_1_mid.png", campId
      elseif campId == SeasonFactionType.Gendarmerie then
        return "Assets/Main/SeasonRes/S4/Sprites/Common/ljq_s4_zhenying_2_mid.png", campId
      end
    end
    return DataCenter.SeasonFactionWarDataManager:GetCampIcon(campId), campId
  else
    local seasonType = SeasonUtil.GetSeasonType(false, true)
    if seasonType == SeasonMapType.NineNationRainforest then
      return SeasonUtil.GetSeason6CampIconPath(SeasonFactionType.Central)
    end
  end
  return nil
end

function ZoneWarManager:GetCampName(serverId, campId)
  serverId = serverId or 0
  if not campId or campId <= 0 then
    campId = self:GetServerCampIndex(serverId)
  end
  if 0 < campId then
    local conf = self.configSchedule and self.configSchedule.cfg
    if conf then
      if campId == SeasonFactionType.Rebels and conf.faction_a_name then
        return Localization:GetString(conf.faction_a_name)
      elseif campId == SeasonFactionType.Gendarmerie and conf.faction_b_name then
        return Localization:GetString(conf.faction_b_name)
      end
    end
    return DataCenter.SeasonFactionWarDataManager:GetCampName(campId)
  end
  if serverId == "???" or serverId == 0 then
    return "???"
  end
  return string.format("#%s", serverId)
end

function ZoneWarManager:ShowCampBubbleTips(rootTrans, campId, config, deltaY)
  if not (rootTrans and campId) or campId <= 0 then
    return
  end
  if not config then
    local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    config = configSchedule and configSchedule.configNow
  end
  if not config then
    return
  end
  if campId == SeasonFactionType.Rebels then
    UIUtil.ShowBubbleTips(Localization:GetString(config.faction_a_desc), rootTrans.position, 0, deltaY, 0, nil, Localization:GetString(config.faction_a_name))
  elseif campId == SeasonFactionType.Gendarmerie then
    UIUtil.ShowBubbleTips(Localization:GetString(config.faction_b_desc), rootTrans.position, 0, deltaY, 0, nil, Localization:GetString(config.faction_b_name))
  end
end

function ZoneWarManager:IsServerKingBattleDay()
  local configSchedule = DataCenter.ZoneWarManager.configSchedule
  if configSchedule then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= configSchedule.crossStartTime and curTime < configSchedule.roundSettleTime then
      return true
    end
  end
  return false
end

function ZoneWarManager:IsInBattlePhase()
  if self.receivedBattleEnd then
    return false
  end
  if not self:IsBattleDay() then
    return false
  end
  local battleStartTime = self.configSchedule and self.configSchedule.breakThroneProtectTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if battleStartTime > curTime then
    return false
  end
  local curRoundInfo = self.roundInfoNow
  if not curRoundInfo then
    return false
  end
  local winState = curRoundInfo.win or 0
  return winState == 0
end

function ZoneWarManager:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("configSchedule\230\149\176\230\141\174\230\156\137\230\149\136: %s", tostring(self.configSchedule ~= nil))
  sb:AppendFormatLine("roundInfoNow\230\149\176\230\141\174\230\156\137\230\149\136: %s", tostring(self.roundInfoNow ~= nil))
  sb:AppendFormatLine("\230\152\175\229\144\166\230\148\182\229\136\176\232\191\135\231\187\147\230\157\159\228\191\161\230\129\175: %s", tostring(self.receivedBattleEnd == true))
  sb:AppendFormatLine("IsInBattlePhase: %s", tostring(self:IsInBattlePhase()))
  local time = self.configSchedule and self.configSchedule.breakThroneProtectTime or 0
  sb:AppendFormatLine("breakThroneProtectTime: %s", UITimeManager:GetInstance():TimeStampToTimeForServer(time))
  sb:AppendFormatLine("roundInfoNow.win: %s", self.roundInfoNow and self.roundInfoNow.win)
  return sb:ToString()
end

return ZoneWarManager
