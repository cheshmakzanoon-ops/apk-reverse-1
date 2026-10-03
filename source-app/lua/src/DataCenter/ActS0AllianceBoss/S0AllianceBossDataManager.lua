local S0AllianceBossDataManager = BaseClass("S0AllianceBossDataManager", CEventable)
local S0AllianceBossInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceBossInfo")
local S0AllianceBattleRecordInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceBattleRecordInfo")
local S0AllianceBossDonateInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceBossDonateInfo")
local S0AllianceBossDetailInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceBossDetailInfo")
local COST_NUM = 1

function S0AllianceBossDataManager:__init()
  self.actStartTime = nil
  self.actEndTime = nil
  self.bossType = nil
  self.lastMoveTime = nil
  self.isSign = nil
  self.battleDayTime = nil
  self.lastDifficultyLevel = nil
  self.openDifficultyLevel = nil
  self.lastSelectTime = nil
  self.bossData = nil
  self.recordMinDifficulty = nil
  self.recordMaxDifficulty = nil
  self.battleRecordList = {}
  self.donateList = {}
  self.firstRewardList = {}
  self.isAutoRally = nil
  self.curDifficulty = nil
  self.curConfigId = nil
  self.actStatus = nil
  self.activityId = nil
  self.activityData = nil
  self.clearResultList = nil
  self.donateGoodsId = nil
  self.donateGetNum = nil
  self.curDonateLevel = nil
  self.curDonateExp = nil
  self.donateAccInfo = nil
  self.donateMulti = nil
  self.donateLevelMax = nil
  self.deadlineOffset = nil
  self.appointMark = nil
  self.movePointId = nil
  self.moveUuid = nil
  self.moveCDTime = nil
  self.requestedEndTimes = {}
  self.mainLevelLimit = nil
  self:AddUpdateTimer()
  self:AddListeners()
end

function S0AllianceBossDataManager:__delete()
  self:RemoveUpdateTimer()
  self:RemoveListeners()
  self:Clear()
  self.actStartTime = nil
  self.actEndTime = nil
  self.bossType = nil
  self.battleRecordList = nil
  self.donateList = nil
  self.firstRewardList = nil
  self.requestedEndTimes = nil
  self.mainLevelLimit = nil
end

function S0AllianceBossDataManager:Clear()
  self.lastMoveTime = nil
  self.isSign = nil
  self.battleDayTime = nil
  self.lastDifficultyLevel = nil
  self.openDifficultyLevel = nil
  self.lastSelectTime = nil
  self.bossData = nil
  self.recordMinDifficulty = nil
  self.recordMaxDifficulty = nil
  self.battleRecordList = {}
  self.donateList = {}
  self.firstRewardList = {}
  self.isAutoRally = nil
  self.curDifficulty = nil
  self.curConfigId = nil
  self.actStatus = nil
  self.activityId = nil
  self.activityData = nil
  self.clearResultList = nil
  self.donateGoodsId = nil
  self.donateGetNum = nil
  self.curDonateLevel = nil
  self.curDonateExp = nil
  self.donateAccInfo = nil
  self.donateMulti = nil
  self.donateLevelMax = nil
  self.deadlineOffset = nil
  self.appointMark = nil
  self.movePointId = nil
  self.moveUuid = nil
  self.moveCDTime = nil
  self.bubbleIsClose = nil
  self.needReqActMainTime = nil
  self.size = nil
end

function S0AllianceBossDataManager:AddListeners()
  self:RegisterEvent(EventId.OnPassDay, self.OnPassDay)
  self:RegisterEvent(EventId.OnEnterCity, self.ExitWorld)
  self:RegisterEvent(EventId.OnEnterWorld, self.EnterWorld)
  self:RegisterEvent(EventId.AllianceApplySuccess, self.OnAllianceApplySuccess)
  self:RegisterEvent(EventId.AllianceQuitOK, self.OnAllianceQuit)
end

function S0AllianceBossDataManager:RemoveListeners()
  self:UnregisterEvent(EventId.OnPassDay)
  self:UnregisterEvent(EventId.OnEnterCity)
  self:UnregisterEvent(EventId.OnEnterWorld)
  self:UnregisterEvent(EventId.AllianceApplySuccess)
  self:UnregisterEvent(EventId.AllianceQuitOK)
end

function S0AllianceBossDataManager:ParseActInfo(message)
  if message == nil then
    return
  end
  local actStatus = AllianceBossS0ActStatus.NoPlan
  self.actStartTime = message.actStartTime or 0
  self.actEndTime = message.actEndTime or 0
  self.bossType = message.bossType or 0
  self.lastMoveTime = message.lastMoveTime or 0
  self.isSign = message.isSign
  self.needReqActMainTime = nil
  if self.isSign == 1 then
    actStatus = AllianceBossS0ActStatus.Prepare
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if curTs >= self.actEndTime then
    actStatus = self.isSign == 1 and AllianceBossS0ActStatus.Finished or AllianceBossS0ActStatus.NoPlan
  end
  self.battleDayTime = message.battleDayTime or 0
  self.lastDifficultyLevel = message.lastDifficultyLevel or 0
  self.openDifficultyLevel = message.openDifficultyLevel or 0
  self.lastSelectTime = message.lastSelectTime
  self:ParseActBossData(message)
  if self.bossData then
    local battleStartTime = self.bossData.battleStartTime
    local battleEndTime = self.bossData.battleEndTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.bossData.bossUuid ~= 0 and 0 < battleStartTime and 0 < battleEndTime then
      if battleStartTime <= curTime and battleEndTime > curTime then
        actStatus = AllianceBossS0ActStatus.InCombat
        self.needReqActMainTime = battleEndTime
        if self.actStatus ~= AllianceBossS0ActStatus.InCombat then
          EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossBattleStart, actStatus)
        end
      elseif battleEndTime <= curTime then
        actStatus = AllianceBossS0ActStatus.Finished
      end
    end
  end
  self.actStatus = actStatus
  self:ParseBattleRecordInfo(message)
  self:ParseFirstRewardList(message)
  table.clear(self.donateList)
  local donateList = message.donateList
  if donateList ~= nil then
    for i, v in ipairs(donateList) do
      local oneData = S0AllianceBossDonateInfo.New()
      oneData:ParseData(v)
      self.donateList[i] = oneData
    end
  end
  self.isAutoRally = message.isAutoRally or 0
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossOnActInfoGot, message)
end

function S0AllianceBossDataManager:ParseActBossData(message)
  if message == nil or message.bossData == nil then
    self.bossData = nil
    return
  end
  if self.bossData == nil then
    self.bossData = S0AllianceBossInfo.New()
  end
  self.bossData:ParseData(message.bossData)
  self.bossData.playerDamage = message.playerDamage
  local curDifficulty = self.bossData.difficultyLevel
  if curDifficulty ~= self.curDifficulty then
    local bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
    local bossId = bossDifficultyIds and bossDifficultyIds[curDifficulty]
    self.curConfigId = bossId
  end
  self.curDifficulty = curDifficulty
  self.curDonateLevel = self.bossData.donateLevel
  self.curDonateExp = self.bossData.donateExp
end

function S0AllianceBossDataManager:ParseBattleRecordInfo(message)
  if message == nil or message.battleRecordList == nil then
    return
  end
  table.clear(self.battleRecordList)
  local recordList = message.battleRecordList
  if recordList ~= nil then
    local maxLevel, minLevel = 0, 999
    local level
    for i, v in ipairs(recordList) do
      local oneData = S0AllianceBattleRecordInfo.New()
      oneData:ParseData(v)
      level = oneData.difficultyLevel
      self.battleRecordList[level] = oneData
      if minLevel > level then
        minLevel = level
      end
      if oneData.mvpInfo and maxLevel < level then
        maxLevel = level
      end
    end
    self.recordMinDifficulty = minLevel
    self.recordMaxDifficulty = maxLevel
  end
end

function S0AllianceBossDataManager:ParseFirstRewardList(message)
  if message == nil or message.firstRewardList == nil then
    return
  end
  table.clear(self.firstRewardList)
  local firstRewardList = message.firstRewardList
  if firstRewardList ~= nil then
    local level
    for _, v in ipairs(firstRewardList) do
      level = v.difficultyLevel
      self.firstRewardList[level] = {
        difficultyLevel = level,
        state = v.state
      }
    end
  end
end

function S0AllianceBossDataManager:ParseAppointmentInfo(message)
  if message == nil then
    return
  end
  self:ParseActBossData(message)
end

function S0AllianceBossDataManager:ParseBossDetailInfo(message)
  if message == nil then
    return
  end
  local oneData = S0AllianceBossDetailInfo.New()
  oneData:ParseData(message)
  return oneData
end

function S0AllianceBossDataManager:ParseCurDonateInfo(message)
  if message == nil then
    return
  end
  self.curDonateLevel = message.donateLevel
  self.curDonateExp = message.donateExp
  local donateAccInfo = message.accInfo
  self.donateMulti = message.multi
  if donateAccInfo and donateAccInfo.accPoint then
    DataCenter.AllianceBaseDataManager:UpdateAccPoint(donateAccInfo.accPoint)
  end
  self.donateAccInfo = donateAccInfo
  local uuid = self.bossData and self.bossData.buildUuid
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossDonateSuccess, uuid)
end

function S0AllianceBossDataManager:ParseDonateInfo(message)
  if message == nil then
    return
  end
  self.curDonateLevel = message.donateLevel
  self.curDonateExp = message.donateExp
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossDonateInfoUpdated)
end

function S0AllianceBossDataManager:ParseAutoRallyData(message)
  if message.errorCode == nil then
    self.isAutoRally = message.isAutoRally
  end
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossAutoRallyChanged, self.isAutoRally)
end

function S0AllianceBossDataManager:ReqActMainMessage(type)
  type = type or 1
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0ActInfo, type)
end

function S0AllianceBossDataManager:ReqAllianceBossS0SelectTime(startTime, difficulty)
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0SelectTime, startTime, difficulty)
end

function S0AllianceBossDataManager:ReqAllianceBossS0Donate()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0Donate)
end

function S0AllianceBossDataManager:RequestMoveBuilding(point)
  self:SetMovingModelState(false)
  if self.actStatus == AllianceBossS0ActStatus.Prepare then
    DataCenter.S0AllianceBossCtrlManager:SetBuildingState(self.moveUuid, false)
  elseif self.actStatus == AllianceBossS0ActStatus.Finished then
    DataCenter.S0AllianceBossCtrlManager:SetBossState(self.moveUuid, false)
  end
  if point and 0 < point and self.movePointId and 0 < self.movePointId and self.bossData then
    SFSNetwork.SendMessage(MsgDefines.MoveAllianceBossS0, self.movePointId, point)
  end
end

function S0AllianceBossDataManager:ReqGainLastTimeInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0GainLastTimeInfo)
end

function S0AllianceBossDataManager:ReqGetRewardInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossCommonRewardInfo, LuaEntry.Player:GetSourceServerId(), self.bossType)
end

function S0AllianceBossDataManager:ReqGetRankInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0TopList, LuaEntry.Player:GetSourceServerId())
end

function S0AllianceBossDataManager:ReqChangeOffline(isOn)
  SFSNetwork.SendMessage(MsgDefines.AllianceBossSetAutoRally, isOn and 1 or 0)
end

function S0AllianceBossDataManager:ReqGetRecordInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0BattleRecord)
end

function S0AllianceBossDataManager:ReqReceiveFirstReward(difficultyLevel)
  SFSNetwork.SendMessage(MsgDefines.ReceiveAllianceBossS0FirstReward, difficultyLevel)
end

function S0AllianceBossDataManager:ReqDonateRecord()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0DonateRecord)
end

function S0AllianceBossDataManager:ReqAllianceBossS0GetDonateInfo()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossS0GetDonateInfo)
end

function S0AllianceBossDataManager:SetActivityData(activityId, activityData)
  self.activityId = activityId
  self.activityData = activityData
end

function S0AllianceBossDataManager:GetRedCount()
  local redCount = 0
  if self:GetDonateRedPoint() then
    redCount = redCount + 1
  end
  local show, count = self:GetFirstRewardRedPoint()
  if show then
    redCount = redCount + count
  end
  return redCount
end

function S0AllianceBossDataManager:GetDonateRedPoint()
  if self.actStatus == AllianceBossS0ActStatus.Prepare then
    local have = DataCenter.ItemData:GetItemCount(self:GetDonateGoodsId())
    return 0 < have
  end
  return false
end

function S0AllianceBossDataManager:GetFirstRewardRedPoint()
  local firstRewardList = self.firstRewardList
  local count = 0
  if firstRewardList then
    for _, v in pairs(firstRewardList) do
      if v and v.state == 1 then
        count = count + 1
      end
    end
  end
  return 0 < count, count
end

function S0AllianceBossDataManager:GetRecordList()
  return self.battleRecordList
end

function S0AllianceBossDataManager:GetActivityData()
  return self.activityData
end

function S0AllianceBossDataManager:GetClearResult(time)
  if time == nil or time < 0 then
    return AllianceBossS0ClearResult.None
  end
  if self.clearResultList == nil then
    local clearResult = LuaEntry.DataConfig:TryGetStr("s0_alliance_boss", "k15")
    if clearResult then
      local arr = string.split(clearResult, "|")
      if arr then
        local list = {}
        for i, v in ipairs(arr) do
          list[i] = tonumber(v) * 60 * 1000
        end
        self.clearResultList = list
      end
    end
  end
  if self.clearResultList then
    local count = #self.clearResultList
    local result = 0
    for i = 1, count do
      local v = self.clearResultList[i]
      if time >= v then
        result = i
      end
    end
    return result
  end
end

function S0AllianceBossDataManager:GetDonateGoodsId()
  if self.donateGoodsId == nil then
    self.donateGoodsId = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k5")
  end
  return self.donateGoodsId
end

function S0AllianceBossDataManager:GetDonateGetNum()
  if self.donateGetNum == nil then
    self.donateGetNum = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k1")
  end
  return self.donateGetNum
end

function S0AllianceBossDataManager:GetDeadlineOffset()
  if self.deadlineOffset == nil then
    self.deadlineOffset = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k16")
  end
  return self.deadlineOffset
end

function S0AllianceBossDataManager:GotoWorldPointOpen(point, serverId)
  if point and 0 < point then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(point, nil, nil, serverId)
  else
    Logger.LogError("S0AllianceBoss -- the point is invalid : " .. point)
  end
end

function S0AllianceBossDataManager:MarkAppointChanged(mark)
  self.appointMark = mark
end

function S0AllianceBossDataManager:GetDonateHintClickNum()
  if self.donateHintClickNum == nil then
    self.donateHintClickNum = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k17")
  end
  return self.donateHintClickNum
end

function S0AllianceBossDataManager:GetDonateHintShowTime()
  if self.donateHintKeepTime == nil then
    local showTime = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k18")
    self.donateHintKeepTime = showTime * 1000
  end
  return self.donateHintKeepTime
end

function S0AllianceBossDataManager:GetBossAttackInternal()
  if self.bossAttackInternal == nil then
    local internal = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k19")
    self.bossAttackInternal = internal * 1000
  end
  return self.bossAttackInternal
end

function S0AllianceBossDataManager:GetCurPersonalDmg()
  if self.bossData then
    return self.bossData.playerDamage
  end
end

function S0AllianceBossDataManager:CheckMoveCd()
  if self.lastMoveTime then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    if curTs - self.lastMoveTime <= self:GetMoveCfgCD() then
      return 2
    end
  end
  return 1
end

function S0AllianceBossDataManager:GetMoveCfgCD()
  if self.moveCDTime == nil then
    local time = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k22", 0)
    self.moveCDTime = time * 1000
  end
  return self.moveCDTime
end

function S0AllianceBossDataManager:GetMoveCD()
  local time = 0
  if self.lastMoveTime then
    time = (self.lastMoveTime + self:GetMoveCfgCD()) / 1000
  end
  return time
end

function S0AllianceBossDataManager:CheckMainLevelLimit()
  if self.mainLevelLimit == nil then
    local limit = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k23", 0)
    self.mainLevelLimit = limit
  end
  local mainLevel = DataCenter.BuildManager:GetMainLevel()
  if mainLevel < self.mainLevelLimit then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("143575", self.mainLevelLimit))
    return false
  end
  return true
end

function S0AllianceBossDataManager:CreateBuildingMovingModel(pointId, uuid)
  if not self:CheckMainLevelLimit() then
    return
  end
  self.movePointId = pointId
  self.moveUuid = uuid
  if self:CheckMoveCd() == 2 then
    UIUtil.ShowTipsId("s0_alliance_boss_transfer_cd_tips")
    return
  end
  if self.bossData == nil then
    return
  end
  if pointId and 0 < pointId and CS.SceneManager.World then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info and info.buildPointInfo then
      GoToUtil.CloseAllWindows()
      local buildPointInfo = info.buildPointInfo
      local bossId = buildPointInfo.cfgId
      if bossId then
        local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
        if bossTemp then
          local modelPath = "Assets/Main/Prefabs/Building/Building_S0AllianceBoss_01_put.prefab"
          if self.size == nil then
            local monsterId = bossTemp.monsterId
            local monsterTemp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
            self.size = monsterTemp and monsterTemp.size or 0
          end
          if modelPath and self.size and 0 < self.size then
            DataCenter.S0AllianceBossCtrlManager:SetBuildingState(uuid, true)
            UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.S0AllianceBuilding, pointId, self.size)
          end
        end
      end
    end
  end
end

function S0AllianceBossDataManager:CreateBossMovingModel(pointId, uuid)
  if not self:CheckMainLevelLimit() then
    return
  end
  self.movePointId = pointId
  self.moveUuid = uuid
  if self:CheckMoveCd() == 2 then
    UIUtil.ShowTipsId("s0_alliance_boss_transfer_cd_tips")
    return
  end
  if self.bossData == nil then
    return
  end
  if pointId and 0 < pointId and uuid and 0 < uuid and CS.SceneManager.World then
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo and marchInfo.s0AllianceBossInfo then
      GoToUtil.CloseAllWindows()
      local s0AllianceBossInfo = marchInfo.s0AllianceBossInfo
      local bossId = s0AllianceBossInfo.cfgId
      if bossId then
        local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
        if bossTemp then
          local modelPath = "Assets/Main/Prefabs/Building/Building_S0AllianceBoss_01_put.prefab"
          if self.size == nil then
            local monsterId = bossTemp.monsterId
            local monsterTemp = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
            self.size = monsterTemp and monsterTemp.size or 0
          end
          if modelPath and self.size and 0 < self.size then
            DataCenter.S0AllianceBossCtrlManager:SetBossState(uuid, true)
            UIUtil.UICreateWorldMovingModel(modelPath, FakeMovingModelFlag.S0AllianceBuilding, pointId, self.size)
          end
        end
      end
    end
  end
end

function S0AllianceBossDataManager:UpdatePersonalDmg(message)
  if message and self.bossData then
    self.bossData.playerDamage = message.selfDamage
  end
end

function S0AllianceBossDataManager:UpdateAllianceDmg(message)
  if message and self.bossData then
    self.bossData.totalDamage = message.totalDamage
  end
end

function S0AllianceBossDataManager:GetWorldPointData(uuid)
  if uuid then
    local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
    if info and info.buildPointInfo then
      local oneData = {}
      oneData.uuid = uuid
      local startTime = info.buildPointInfo.startTime
      if startTime == 0 then
        oneData.canAttack = true
      elseif info.serverId == LuaEntry.Player:GetSourceServerId() then
        oneData.canAttack = true
      end
      local bossId = info.buildPointInfo.cfgId
      local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
      if bossTemp then
        local name = bossTemp.name
        local level = bossTemp.difficulty
        oneData.level = level
        oneData.name = name
        oneData.shareName = CS.GameEntry.Localization:GetString(name)
      end
      local isMine = info.buildPointInfo.allianceId == LuaEntry.Player.allianceId
      oneData.isMine = isMine
      return oneData
    end
  end
end

function S0AllianceBossDataManager:SetMovingModelState(hide, cancel)
  if self.actStatus == AllianceBossS0ActStatus.Prepare then
    DataCenter.S0AllianceBossCtrlManager:SetBuildingState(self.moveUuid, hide, cancel)
  elseif self.actStatus == AllianceBossS0ActStatus.Finished then
    DataCenter.S0AllianceBossCtrlManager:SetBossState(self.moveUuid, hide, cancel)
  end
end

function S0AllianceBossDataManager:CheckVisitorStatus()
  if self.actEndTime then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    if curTs >= self.actEndTime then
      return false, 3
    end
    if self.actStatus == AllianceBossS0ActStatus.Prepare then
      return false, 1
    end
    if self.actStatus >= AllianceBossS0ActStatus.InCombat then
      return false, 1
    end
    if curTs < self.battleDayTime then
      return false
    end
    return true, 2
  end
  return false
end

function S0AllianceBossDataManager:GotoActivityPanel()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.Alliance, self.activityId)
  end
end

function S0AllianceBossDataManager:GoToDonatePanel()
  if not self:CheckMainLevelLimit() then
    return
  end
  if self.actStatus == AllianceBossS0ActStatus.Prepare then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossBuild, {anim = true}, true)
  else
    Logger.LogError("S0AllianceBoss -- donate cannot show")
  end
end

function S0AllianceBossDataManager:GoToSelectLevePanel()
  if not self:CheckMainLevelLimit() then
    return
  end
  if self.actStatus == AllianceBossS0ActStatus.Prepare and self.curDifficulty then
    local param = {
      viewDifficulty = self.curDifficulty,
      curDifficulty = self.curDifficulty
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossSelect, {anim = true}, param)
  else
    Logger.LogError("S0AllianceBoss -- select level cannot show")
  end
end

function S0AllianceBossDataManager:GoToRewardPreviewPanel()
  if not self:CheckMainLevelLimit() then
    return
  end
  if self.actStatus >= AllianceBossS0ActStatus.Prepare and self.curDifficulty then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRewardPreview, {anim = true}, {
      viewDifficulty = self.curDifficulty
    })
  else
    Logger.LogError("S0AllianceBoss -- select level cannot show")
  end
end

function S0AllianceBossDataManager:CheckBattleBubbleShow()
  if self.bubbleIsClose then
    return false
  end
  if self.bossData then
    local bossUuid = self.bossData.bossUuid
    if 0 < bossUuid then
      local battleStartTime = self.bossData.battleStartTime
      local battleEndTime = self.bossData.battleEndTime
      local curTs = UITimeManager:GetInstance():GetServerTime()
      if battleStartTime <= curTs and battleEndTime > curTs then
        return true
      end
    end
  end
  return false
end

function S0AllianceBossDataManager:SetBattleBubbleHide()
  self.bubbleIsClose = true
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossBattleBubbleRefresh)
end

function S0AllianceBossDataManager:UpdateLastMoveTime(lastMoveTime)
  self.lastMoveTime = lastMoveTime
end

function S0AllianceBossDataManager:CheckBuildBubbleShow()
  if self:CheckBuildingDonateFull() then
    return false
  end
  local goodsId = self:GetDonateGoodsId()
  if goodsId then
    local have = DataCenter.ItemData:GetItemCount(goodsId)
    return have >= COST_NUM
  end
  return false
end

function S0AllianceBossDataManager:CheckBuildingDonateFull()
  if self.curConfigId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(self.curConfigId)
    if bossTemp then
      local donateMaxLevel = bossTemp:GetDonateMaxLevel()
      return donateMaxLevel == self.curDonateLevel
    end
  end
end

function S0AllianceBossDataManager:CheckShowS0AllianceBossVisitor()
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return
  end
  if self.activityId == nil or self.activityData == nil then
    local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.S0AllianceBoss.Type)
    if actData == nil then
      return
    end
  end
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.S0AllianceBossVisitorRemind) then
    DataCenter.S0AllianceBossDataManager:ReqActMainMessage(2)
  end
end

function S0AllianceBossDataManager:UpdateS0AllianceBossVisitorNoShow()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.S0AllianceBossVisitorRemind, false)
end

function S0AllianceBossDataManager:GoToRewardRankPanel()
  if not self:CheckMainLevelLimit() then
    return
  end
  if self.actStatus >= AllianceBossS0ActStatus.InCombat then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRank)
  else
    Logger.LogError("S0AllianceBoss -- status error, cur statue = " .. self.actStatus)
  end
end

function S0AllianceBossDataManager:CheckAlliancePersonalDmgFull()
  if self.bossData and self.curDifficulty and self.curConfigId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(self.curConfigId)
    if bossTemp then
      local allianceMaxDmg = bossTemp.allianceMaxDmg
      local personalMaxDmg = bossTemp.personalMaxDmg
      local totalDamage = self.bossData.totalDamage
      local playerDamage = self.bossData.playerDamage
      return allianceMaxDmg <= totalDamage and personalMaxDmg <= playerDamage
    end
  end
end

function S0AllianceBossDataManager:GetActOpenMemberNum()
  if self.actOpenMemberNum == nil then
    local actOpenMemberNum = LuaEntry.DataConfig:TryGetNum("s0_alliance_boss", "k2")
    self.actOpenMemberNum = actOpenMemberNum
  end
  return self.actOpenMemberNum
end

function S0AllianceBossDataManager:IsAllyMemberNumEnough()
  local actOpenMemberNum = self:GetActOpenMemberNum()
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local memberNum = alData and alData.curMember or 0
  return actOpenMemberNum <= memberNum
end

function S0AllianceBossDataManager:GetBattleEndTime()
  return self.bossData and self.bossData.battleEndTime
end

function S0AllianceBossDataManager:OnPassDay()
  self.bubbleIsClose = nil
  DataCenter.AllianceBossS0TemplateManager:ClearData()
end

function S0AllianceBossDataManager:EnterWorld()
  DataCenter.S0AllianceBossCtrlManager:EnterWorld()
end

function S0AllianceBossDataManager:ExitWorld()
  DataCenter.S0AllianceBossCtrlManager:ExitWorld()
end

function S0AllianceBossDataManager:OnAllianceApplySuccess()
  if self.activityId == nil or self.activityData == nil then
    local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.S0AllianceBoss.Type)
    if actData == nil then
      return
    end
    self:SetActivityData(actData.id, actData)
  end
  self:ReqActMainMessage()
end

function S0AllianceBossDataManager:OnAllianceQuit()
  self:Clear()
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossBattleBubbleRefresh)
end

function S0AllianceBossDataManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function S0AllianceBossDataManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function S0AllianceBossDataManager:OnUpdate()
  if self.needReqActMainTime and self.requestedEndTimes and self.requestedEndTimes[self.needReqActMainTime] == nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.needReqActMainTime then
      DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
      self.requestedEndTimes[self.needReqActMainTime] = true
      self.needReqActMainTime = nil
    end
  end
end

return S0AllianceBossDataManager
