local AllyDrillDataManager = BaseClass("AllyDrillDataManager")
local AllyDrillMeta = require("DataCenter.AllyDrill.AllyDrillMeta")
local AllyDrillRoadHogMeta = require("DataCenter.AllyDrill.AllyDrillRoadHogMeta")
local TWO_HOUR = 7200000
local HALF_HOUR = 1800000

function AllyDrillDataManager:__init()
  self.actInfo = {}
  self.reward = {}
  self.timeInfo = {}
  self.clickedAttackBtn = false
  self.stage = AllyDrillStage.NotStart
end

function AllyDrillDataManager:__delete()
  self.actInfo = nil
  self.newBossData = nil
  self.maxUnlockNewBossLevel = nil
  self.newBossDonateDatas = nil
  self.newBossUnlockCondition = nil
  self.newBossUnlockLevels = nil
  self.level2IdMap = nil
  self.roadHogMeta = nil
  self.reward = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timeInfo = nil
  self.abTest = nil
  self.bossSandWormCallMonsterIds = nil
end

function AllyDrillDataManager:Startup()
  self:InitMeta()
end

function AllyDrillDataManager:CheckIfIsInCompete()
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

function AllyDrillDataManager:SendMsgAllianceBossActInfo(isForce)
  if not isForce then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if self.lastSendTime and now < self.lastSendTime + 5 then
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossActInfo, LuaEntry.Player:GetSourceServerId())
  self.lastSendTime = UITimeManager:GetInstance():GetServerSeconds()
end

function AllyDrillDataManager:RecMsgAllianceBossActInfo(msg)
  self.actInfo = msg
  self:RefreshStage()
  self.bossType = self.actInfo.bossType or AllyDrillBoss.TankBoss
  self:CheckAndInitNewBossData(self.actInfo.data)
  if msg.digGameInfo then
    self.digGameInfo = msg.digGameInfo
  end
  DataCenter.AllyDrillDataManager:SendMsgAllianceBossRewardInfo()
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
end

function AllyDrillDataManager:CheckAndInitNewBossData(data)
  if not data then
    return nil
  end
  if data.dataS3 then
    self.newBossData = data.dataS3
  end
  return self.newBossData
end

function AllyDrillDataManager:GetNewBossData()
  return self.newBossData
end

function AllyDrillDataManager:IsNewBoss()
  return self.bossType ~= AllyDrillBoss.TankBoss
end

function AllyDrillDataManager:GetBossType()
  return self.bossType or AllyDrillBoss.TankBoss
end

function AllyDrillDataManager:SendMsgAllianceBossDetail(uuid)
  SFSNetwork.SendMessage(MsgDefines.AllianceBossDetail, uuid, LuaEntry.Player:GetCurServerId())
end

function AllyDrillDataManager:RecMsgAllianceBossDetail(msg)
  if self.actInfo and self.actInfo.data and self.actInfo.data.bossUuid and self.actInfo.data.bossUuid == msg.uuid then
    self.actInfo.data.totalDamage = msg.damage
    self.actInfo.data.currBonus = msg.bonus
    self:CheckAndInitNewBossData(msg)
  end
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillBossInfoGet, msg)
end

function AllyDrillDataManager:SendMsgAllianceBossDonate(num)
  if not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(2010392)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossDonate, num)
end

function AllyDrillDataManager:RecMsgAllianceBossDonate(msg)
  if self.actInfo and self.actInfo.data then
    self.actInfo.data.donateLevel = msg.donateLevel
    self.actInfo.data.donateExp = msg.donateExp
  end
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillDonateSuccess, msg)
end

function AllyDrillDataManager:SendMsgAllianceBossRewardInfo()
  if self.bossType == AllyDrillBoss.TankBoss then
    SFSNetwork.SendMessage(MsgDefines.AllianceBossRewardInfo, LuaEntry.Player:GetSourceServerId())
  elseif self.bossType == AllyDrillBoss.HugeSandWorm then
    SFSNetwork.SendMessage(MsgDefines.AllianceBossS3RewardInfo, LuaEntry.Player:GetSourceServerId())
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceBossCommonRewardInfo, LuaEntry.Player:GetSourceServerId(), self.bossType)
  end
end

function AllyDrillDataManager:RecMsgAllianceBossRewardInfo(msg)
  self.reward = msg
end

function AllyDrillDataManager:SendMsgAllianceBossSelectTime(timeStamp, difficulty)
  if not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId(2010391)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossSelectTime, timeStamp, difficulty)
end

function AllyDrillDataManager:RecMsgAllianceBossSelectTime(msg)
  self.actInfo.data = msg.data
  self:RefreshStage()
  self:CheckAndInitNewBossData(msg.data)
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
  self:JumpToDrill()
end

function AllyDrillDataManager:SendMsgAllianceBossStart()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossStart)
end

function AllyDrillDataManager:RecMsgAllianceBossStart(msg)
  if self.actInfo.data then
    self.actInfo.data.battleStartTime = msg.battleStartTime
    self.actInfo.data.battleEndTime = msg.battleEndTime
    self:RefreshStage()
    EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
  end
end

function AllyDrillDataManager:SendMsgAllianceBossTopList()
  SFSNetwork.SendMessage(MsgDefines.AllianceBossTopList, LuaEntry.Player:GetSourceServerId())
end

function AllyDrillDataManager:RecMsgAllianceBossTopList(msg)
  self.rank = msg
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillRankRefresh)
end

function AllyDrillDataManager:RecMsgPushAllianceBossCreate(msg)
  self:SendMsgAllianceBossActInfo(true)
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillBaseCreaterName, msg.userName)
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillBaseCreate, msg.uuid)
end

function AllyDrillDataManager:RecMsgPushAllianceBossStart(msg)
  self.bossUuid = msg.bossUuid
  self:SendMsgAllianceBossActInfo(true)
  DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.AllyDrill1)
end

function AllyDrillDataManager:RecMsgPushAllianceJoin(msg)
  if self.stage == AllyDrillStage.NotStart or self.stage == AllyDrillStage.End then
    return
  end
  self:SendMsgAllianceBossActInfo(true)
end

function AllyDrillDataManager:SendChangeAutoRally(isAutoRally)
  SFSNetwork.SendMessage(MsgDefines.AllianceBossSetAutoRally, isAutoRally and 1 or 0)
end

function AllyDrillDataManager:RecMsgChangeAutoRally(msg)
  self.actInfo.isAutoRally = msg.isAutoRally
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillAutoRallyChanged)
end

function AllyDrillDataManager:SendGetLastTimeInfo(allianceId)
  SFSNetwork.SendMessage(MsgDefines.AllianceLastSelectTime, allianceId)
end

function AllyDrillDataManager:RecMsgLastTimeInfo(msg)
  self.timeInfo = msg
end

function AllyDrillDataManager:GetLastTimeInfo()
  return self.timeInfo
end

function AllyDrillDataManager:GetLastAttendTime()
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.ALLY_DRILL_LAST_ATTEND_TIME, false)
end

function AllyDrillDataManager:RefreshStage()
  local oldStage = self.stage or AllyDrillStage.NotStart
  local msg = self.actInfo
  if not msg then
    self.stage = AllyDrillStage.NotStart
    return
  end
  local realActEndTime = msg.actEndTime
  if msg.data and msg.data.battleEndTime and msg.data.battleEndTime > msg.actEndTime then
    realActEndTime = msg.data.battleEndTime
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < msg.actStartTime then
    self.stage = AllyDrillStage.NotStart
    self.nextTs = msg.actStartTime
  elseif realActEndTime < now then
    self.stage = AllyDrillStage.End
    self.nextTs = nil
  elseif not LuaEntry.Player:IsInAlliance() then
    self.stage = AllyDrillStage.SelectStage
    self.nextTs = msg.actEndTime
  elseif msg.isSign == 0 then
    if now < msg.battleDayTime + TWO_HOUR then
      self.stage = AllyDrillStage.SelectStage
      self.nextTs = msg.battleDayTime + TWO_HOUR
    elseif now < msg.actEndTime - HALF_HOUR then
      self.stage = AllyDrillStage.SelectStage
      self.nextTs = msg.actEndTime - HALF_HOUR
    else
      self.stage = AllyDrillStage.End
      self.nextTs = nil
    end
  elseif msg.data == nil then
    Logger.LogError("msg.isSign~=0 \228\189\134\230\152\175 msg.data==\231\169\186")
    self.stage = AllyDrillStage.SelectStage
    self.nextTs = msg.actEndTime
  elseif now < msg.data.readyTime then
    self.stage = AllyDrillStage.PrepareStage
    self.nextTs = msg.data.readyTime
    local fromNowToReady = (msg.data.readyTime - now) * 0.001 + 3
    if not self.timer and 0 < fromNowToReady then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshStage()
        self.timer = nil
      end, fromNowToReady)
    end
  elseif 0 >= msg.data.battleStartTime then
    self.stage = AllyDrillStage.ReadyStage
    self.nextTs = msg.actEndTime
  elseif now > msg.data.battleEndTime then
    self.stage = AllyDrillStage.SettleStage
    self.nextTs = msg.actEndTime
  else
    self.stage = AllyDrillStage.AttackStage
    self.nextTs = msg.data.battleEndTime
    local fromNowToHalf = (msg.data.battleStartTime + 900000 - now) * 0.001
    if not self.timer and 0 < fromNowToHalf then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self:SendMsgAllianceBossActInfo(true)
        DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.AllyDrill2)
        self.timer = nil
      end, fromNowToHalf)
    end
    local fromNowToEnd = (msg.data.battleEndTime - now) * 0.001 + 3
    if not self.timer and 0 < fromNowToEnd then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshStage()
        self.timer = nil
      end, fromNowToEnd)
    end
  end
  if self.stage ~= oldStage then
    EventManager:GetInstance():Broadcast(EventId.OnAllyDrillStageChange, self.stage)
  end
end

function AllyDrillDataManager:CheckShowTip(condition)
  if self.stage == AllyDrillStage.AttackStage then
    local startTime = self.actInfo.data.battleStartTime
    local endTime = self.actInfo.data.battleEndTime
    local midTime = (startTime + endTime) * 0.5
    local now = UITimeManager:GetInstance():GetServerTime()
    if condition == MainUITipCondition.AllyDrill1 and not self.Tip1 and startTime < now and midTime > now then
      return true
    elseif condition == MainUITipCondition.AllyDrill2 and not self.Tip2 and midTime < now and endTime > now then
      return true
    end
  end
end

function AllyDrillDataManager:SetShowTip(condition)
  if condition == MainUITipCondition.AllyDrill1 then
    self.Tip1 = true
  elseif condition == MainUITipCondition.AllyDrill1 then
    self.Tip2 = true
  end
end

function AllyDrillDataManager:InitMeta()
  local rallyBuff = LuaEntry.DataConfig:TryGetStr("alliance_boss", "k8")
  rallyBuff = string.split(rallyBuff, "|")
  self.r4buff = string.GetFormattedPercentStr(tonumber(rallyBuff[1]) or 0.025)
  self.r5buff = string.GetFormattedPercentStr(tonumber(rallyBuff[2]) or 0.05)
  self.donateGoodsId = LuaEntry.DataConfig:TryGetNum("alliance_boss", "k5", 710003)
  self.revealLevel = LuaEntry.DataConfig:TryGetStr("alliance_boss", "k9", "1,1,1,7,14,21,30,45,60,90")
  self.revealLevel = string.split(self.revealLevel, ",")
  for i = 1, #self.revealLevel do
    self.revealLevel[i] = tonumber(self.revealLevel[i])
  end
end

function AllyDrillDataManager:GetMaxRevealLevel()
  local openServerDay = UITimeManager:GetInstance():GetServerOpenDays()
  if self.revealLevel then
    for i = 1, #self.revealLevel do
      if openServerDay < self.revealLevel[i] then
        return i - 1
      end
    end
  end
  return 99999
end

function AllyDrillDataManager:GetCurStageAndCountDown()
  return self.stage, self.nextTs
end

function AllyDrillDataManager:GetAutoRally()
  if self.actInfo and self.actInfo.isAutoRally then
    return self.actInfo.isAutoRally == 1
  end
  return true
end

function AllyDrillDataManager:GetShowNewBackground()
  if self.actInfo and self.actInfo.showNewBackground == 1 then
    return true
  end
  return false
end

function AllyDrillDataManager:GetActInfo()
  return self.actInfo
end

function AllyDrillDataManager:GetCfg(difficulty)
  if self.bossType == AllyDrillBoss.HugeSandWorm then
    return self:GetAllyDrillSandwormCfg(difficulty)
  elseif self.bossType == AllyDrillBoss.RoadHog then
    return self:GetAllyDrillRoadHogCfg(difficulty)
  else
    return self:GetAllyDrillTankCfg(difficulty)
  end
end

function AllyDrillDataManager:GetAllyDrillTankCfg(difficulty)
  if not self.meta then
    self.meta = {}
    LocalController:instance():visitTable(TableName.LW_Ally_Drill, function(id, lineData)
      if lineData ~= nil then
        self.meta[lineData.id] = lineData
        local item = AllyDrillMeta.New()
        item:InitConfig(lineData)
        if item.id ~= nil then
          self.meta[item.id] = item
        end
      end
    end)
  end
  if difficulty then
    return self.meta[difficulty]
  else
    return self.meta
  end
end

function AllyDrillDataManager:GetAllyDrillSandwormCfg(level)
  if not self.level2IdMap then
    self.level2IdMap = {}
    LocalController:instance():visitTable(TableName.LW_Ally_Drill_New_Boss, function(id, lineData)
      if lineData ~= nil then
        self.level2IdMap[lineData.level] = lineData.id
      end
    end)
  end
  local readId = self.level2IdMap[level]
  if readId then
    return LocalController:instance():getLine(TableName.LW_Ally_Drill_New_Boss, readId)
  end
end

function AllyDrillDataManager:GetAllyDrillRoadHogCfg(level)
  if not self.roadHogMeta then
    self.roadHogMeta = {}
    self.cowDamage = {}
    LocalController:instance():visitTable(TableName.LW_AllyDrillRoadHog, function(id, lineData)
      if lineData ~= nil then
        local item = AllyDrillRoadHogMeta.New()
        item:InitConfig(lineData)
        if item.level ~= nil then
          self.roadHogMeta[item.level] = item
        end
        local cow_hurt = lineData:getValue("cow_hurt")
        cow_hurt = string.split(cow_hurt, "|")
        for _, v in pairs(cow_hurt) do
          local pairStr = string.split(v, ";")
          if #pairStr == 2 then
            self.cowDamage[tonumber(pairStr[1])] = tonumber(pairStr[2])
          end
        end
      end
    end)
  end
  if level then
    return self.roadHogMeta[level]
  else
    return self.roadHogMeta
  end
end

function AllyDrillDataManager:GetCowDamage(monsterId)
  self:GetAllyDrillRoadHogCfg()
  return self.cowDamage[monsterId] or 1000
end

function AllyDrillDataManager:GetBossSandWormCallMonsterIds()
  if not self.bossSandWormCallMonsterIds then
    self.bossSandWormCallMonsterIds = {}
    local calledMonsterIdsStr = LuaEntry.DataConfig:TryGetStr("alliance_boss", "k21")
    if not string.IsNullOrEmpty(calledMonsterIdsStr) then
      local idStrs = string.split(calledMonsterIdsStr, "|")
      for i = 1, #idStrs do
        local monsterId = tonumber(idStrs[i])
        table.insert(self.bossSandWormCallMonsterIds, monsterId)
      end
    end
  end
  return self.bossSandWormCallMonsterIds
end

function AllyDrillDataManager:IsMonsterBossSandWormCall(monsterId)
  local monsterIds = self:GetBossSandWormCallMonsterIds()
  return table.indexof(monsterIds, monsterId)
end

function AllyDrillDataManager:GetNewBossUnlockedLevels()
  local seasonIndex = SeasonUtil.GetSeason()
  local seasonDayNow = SeasonUtil.GetSeasonDay()
  if not self.newBossUnlockLevels or self.seasonDayNow ~= seasonDayNow then
    self.newBossUnlockLevels = {}
    self.seasonDayNow = seasonDayNow
    self.maxUnlockNewBossLevel = 0
    if self.bossType == AllyDrillBoss.HugeSandWorm then
      LocalController:instance():visitTable(TableName.LW_Ally_Drill_New_Boss, function(id, lineData)
        if lineData ~= nil then
          local unlockDay = 0
          local cfgUnlockDay = lineData.unlock_day
          if not string.IsNullOrEmpty(cfgUnlockDay) then
            unlockDay = tonumber(cfgUnlockDay)
          end
          if 4 <= seasonIndex or seasonIndex == 3 and unlockDay <= self.seasonDayNow then
            table.insert(self.newBossUnlockLevels, lineData.level)
            if not self.maxUnlockNewBossLevel or lineData.level > self.maxUnlockNewBossLevel then
              self.maxUnlockNewBossLevel = lineData.level
            end
          end
        end
      end)
      table.sort(self.newBossUnlockLevels, function(idA, idB)
        return idA < idB
      end)
    elseif self.bossType == AllyDrillBoss.RoadHog then
      LocalController:instance():visitTable(TableName.LW_AllyDrillRoadHog, function(id, lineData)
        if lineData ~= nil then
          table.insert(self.newBossUnlockLevels, lineData.level)
          if not self.maxUnlockNewBossLevel or lineData.level > self.maxUnlockNewBossLevel then
            self.maxUnlockNewBossLevel = lineData.level
          end
        end
      end)
      table.sort(self.newBossUnlockLevels, function(idA, idB)
        return idA < idB
      end)
    end
  end
  return self.maxUnlockNewBossLevel, self.newBossUnlockLevels
end

function AllyDrillDataManager:GetNewBossDonateLevelCfg(level)
  local cfgData = self:GetAllyDrillSandwormCfg(level)
  if not cfgData then
    return 1
  end
  if not self.newBossDonateDatas then
    self.newBossDonateDatas = {}
  end
  if not self.newBossDonateDatas[level] then
    self.newBossDonateDatas[level] = {}
    local levelToNeed = {}
    local donate_level = cfgData:getValue("donate_level")
    donate_level = string.split(donate_level, "|")
    for i = 1, #donate_level do
      local data = string.split(donate_level[i], ";")
      local donateLevel = tonumber(data[1])
      local need = tonumber(data[2])
      levelToNeed[donateLevel] = need
    end
    self.newBossDonateDatas[level].needNumber = levelToNeed
    local levelToBonus = {}
    local donate_bonus = cfgData:getValue("donate_level_bouns")
    donate_bonus = string.split(donate_bonus, "|")
    for i = 1, #donate_bonus do
      local data = string.split(donate_bonus[i], ";")
      local donateLevel = tonumber(data[1])
      local bonus = tonumber(data[2])
      levelToBonus[donateLevel] = bonus
    end
    self.newBossDonateDatas[level].bonus = levelToBonus
  end
  return self.newBossDonateDatas[level]
end

function AllyDrillDataManager:GetNewBossUnlockCondition(level)
  if self.bossType == AllyDrillBoss.HugeSandWorm then
    local cfgData = self:GetAllyDrillSandwormCfg(level)
    if not cfgData then
      return 1
    end
    if not self.newBossUnlockCondition then
      self.newBossUnlockCondition = {}
    end
    if not self.newBossUnlockCondition[level] then
      local unlockConditions = {}
      local unlockCondition = cfgData:getValue("unlock_condition")
      local conditions = string.split(unlockCondition, ";")
      local unlockLevel = tonumber(conditions[2])
      local unlockStage = tonumber(conditions[3])
      unlockConditions.unlockLevel = unlockLevel
      unlockConditions.unlockStage = unlockStage
      self.newBossUnlockCondition[level] = unlockConditions
    end
    return self.newBossUnlockCondition[level]
  elseif self.bossType == AllyDrillBoss.RoadHog then
    local cfgData = self:GetAllyDrillRoadHogCfg(level)
    if not cfgData then
      return 1
    end
    if not self.newBossUnlockCondition then
      self.newBossUnlockCondition = {}
    end
    if not self.newBossUnlockCondition[level] then
      local unlockConditions = {}
      local unlockCondition = cfgData.unlock_condition
      local conditions = string.split(unlockCondition, ";")
      local unlockLevel = tonumber(conditions[2])
      local unlockStage = tonumber(conditions[3])
      unlockConditions.unlockLevel = unlockLevel
      unlockConditions.unlockStage = unlockStage
      self.newBossUnlockCondition[level] = unlockConditions
    end
    return self.newBossUnlockCondition[level]
  end
end

function AllyDrillDataManager:GetRankData()
  return self.rank
end

function AllyDrillDataManager:GetRewardData()
  if self.actInfo and self.actInfo.data and self.reward then
    local diff = tostring(self.actInfo.data.difficultyLevel)
    local ret = {}
    if self.reward.allianceReward then
      ret.allianceReward = self.reward.allianceReward[diff]
    end
    if self.reward.personReward then
      ret.personReward = self.reward.personReward[diff]
    end
    if self.reward.allianceBonus then
      ret.allianceBonus = self.reward.allianceBonus[diff]
    end
    return ret
  end
end

function AllyDrillDataManager:GetCurAllyRewardData()
  local rewardList = self:GetRewardData()
  if rewardList == nil then
    return nil
  end
  if self.bossType ~= AllyDrillBoss.TankBoss and self.bossType ~= AllyDrillBoss.RoadHog then
    return nil
  end
  local curTotalDamage = self.actInfo.data and self.actInfo.data.totalDamage or 0
  local curRealReward = {}
  local curShowReward = {}
  local nextRewardDamage = 1
  if curTotalDamage == 0 then
    curShowReward = rewardList.allianceReward[1].reward
    nextRewardDamage = rewardList.allianceReward[1].max
  else
    for i = 1, #rewardList.allianceReward do
      local v = rewardList.allianceReward[i]
      if curTotalDamage >= v.min and (0 > v.max or curTotalDamage <= v.max) then
        curShowReward = v.reward
        curRealReward = v.reward
        nextRewardDamage = v.max
        break
      end
    end
  end
  return curShowReward, curRealReward, nextRewardDamage, rewardList.allianceReward, curTotalDamage
end

function AllyDrillDataManager:GetCurAllyS3RewardData()
  local rewardList = self:GetRewardData()
  if rewardList == nil then
    return nil
  end
  if self.bossType ~= AllyDrillBoss.HugeSandWorm then
    return nil
  end
  local s3Data = self.actInfo.data and self.actInfo.data.dataS3
  if not s3Data then
    return nil
  end
  local isStageEnd = s3Data.curHp <= 0
  local curStage = s3Data.stage or 1
  local curRewardIndex = curStage + (isStageEnd and 1 or 0)
  local curRealReward = {}
  local curShowReward = {}
  if rewardList.allianceReward then
    curRealReward = rewardList.allianceReward[curRewardIndex].reward
    curShowReward = rewardList.allianceReward[curRewardIndex].reward
  end
  local rewardLength = #rewardList.allianceReward
  for i, v in ipairs(rewardList.allianceReward) do
    v.min = i - 1
    v.max = i >= rewardLength and -1 or i
  end
  return curShowReward, curRealReward, rewardList.allianceReward, curRewardIndex
end

function AllyDrillDataManager:GetCurPersonalRewardData()
  local rewardList = self:GetRewardData()
  if rewardList == nil then
    return nil
  end
  local curTotalDamage = self.rank and self.rank.selfDamage or 0
  local curPersonalReward = {}
  if curTotalDamage == 0 then
    curPersonalReward = {}
  else
    for i = 1, #rewardList.personReward do
      local v = rewardList.personReward[i]
      if curTotalDamage >= v.min and (0 > v.max or curTotalDamage <= v.max) then
        curPersonalReward = v.reward
        break
      end
    end
  end
  return curPersonalReward, rewardList.personReward, curTotalDamage
end

function AllyDrillDataManager:GetBuffValue()
  return self.r4buff, self.r5buff
end

function AllyDrillDataManager:GetDonateGoodsId()
  return self.donateGoodsId
end

function AllyDrillDataManager:JumpToDrill()
  if self.actInfo and self.actInfo.data then
    local data = self.actInfo.data
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(data.bossPointId, ForceChangeScene.World), nil, nil, function()
      UIUtil.OnClickWorldTroop(self.actInfo.data.bossUuid)
    end, data.bossServerId)
  end
end

function AllyDrillDataManager:SetHasClickedAttackBtn()
  self.clickedAttackBtn = true
end

function AllyDrillDataManager:GetRedDotCount()
  local ret = 0
  if self:HasRedDotOnGoBtn() then
    ret = ret + 1
  end
  if self:HasRedDotOnDonateBtn() then
    ret = ret + 1
  end
  return ret
end

function AllyDrillDataManager:HasRedDotOnGoBtn()
  if not self.stage then
    return false
  end
  if self.stage == AllyDrillStage.SelectStage or self.stage == AllyDrillStage.ReadyStage then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      return true
    end
  elseif self.stage == AllyDrillStage.AttackStage then
    return not self.clickedAttackBtn
  elseif self.stage == AllyDrillStage.SettleStage then
    return self:ShowDigRedPoint()
  end
  return false
end

function AllyDrillDataManager:HasRedDotOnDonateBtn()
  if not self.stage then
    return false
  end
  if self.stage >= AllyDrillStage.PrepareStage and self.stage <= AllyDrillStage.AttackStage then
    local own = DataCenter.ItemData:GetItemCount(self.donateGoodsId)
    return 10 <= own
  end
  return false
end

function AllyDrillDataManager:GetMoveCD()
  local time = 0
  if self.actInfo and self.actInfo.lastMoveTime then
    time = self.actInfo.lastMoveTime / 1000 + LuaEntry.DataConfig:TryGetNum("allyDrill_move_cd", "k1", 0)
  end
  return time
end

function AllyDrillDataManager:GetStageLanguageKey(stage)
  if stage == 2 then
    return "alliance_boss_tips_003"
  end
  return "alliance_boss_tips_002"
end

function AllyDrillDataManager:GetNewStageAB()
  if self.abTest ~= nil then
    return self.abTest
  end
  local server = LuaEntry.Player:GetSourceServerId()
  if CS.CommonUtils.IsDebug() then
    local serverArray = LuaEntry.DataConfig:TryGetStr("alliance_boss", "k11")
    if not string.IsNullOrEmpty(serverArray) then
      local array = string.split(serverArray, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, "-")
        if #list == 2 then
          local startServer = tonumber(list[1])
          local endServer = tonumber(list[2])
          if startServer <= endServer and server >= startServer and server <= endServer then
            self.abTest = true
            return self.abTest
          end
        elseif #list == 1 then
          local se = tonumber(list[1]) or 0
          if 0 < se and se == server then
            self.abTest = true
            return self.abTest
          end
        end
      end
    end
  else
    local serverArray = LuaEntry.DataConfig:TryGetStr("alliance_boss", "k12")
    if not string.IsNullOrEmpty(serverArray) then
      local array = string.split(serverArray, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, "-")
        if #list == 2 then
          local startServer = tonumber(list[1])
          local endServer = tonumber(list[2])
          if startServer <= endServer and server >= startServer and server <= endServer then
            self.abTest = true
            return self.abTest
          end
        elseif #list == 1 then
          local se = tonumber(list[1]) or 0
          if 0 < se and se == server then
            self.abTest = true
            return self.abTest
          end
        end
      end
    end
  end
  self.abTest = false
  return false
end

function AllyDrillDataManager:ShowDigRedPoint()
  return self.bossType == AllyDrillBoss.RoadHog and self:HasDigGame() and self.digGameInfo.rewardState and self.digGameInfo.rewardState ~= 2
end

function AllyDrillDataManager:HasDigGame()
  if not self.digGameInfo or not self.digGameInfo.uuid then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.digGameInfo.endTime then
    return false
  end
  return true
end

function AllyDrillDataManager:OpenBrick(uuid, uid, pos, type)
  local mapData = DataCenter.DiggingDataManager.curMapData
  if not mapData or mapData.uuid ~= uuid then
    return false
  end
  if mapData.rewardState and mapData.rewardState > 0 then
    UIUtil.ShowTipsId("alliance_boss_treasure_tips")
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossDigGameOpen, uuid, pos)
  return true
end

function AllyDrillDataManager:OnDigGameCreate(message)
  if message.redNum then
    if message.redNum ~= 0 then
      message.rewardState = 1
    else
      message.rewardState = 0
    end
  else
    message.rewardState = 0
  end
  self.digGameInfo = message
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameRedUpdate)
end

function AllyDrillDataManager:UpdateDigOnRewardState(message)
  if not self.digGameInfo or self.digGameInfo.uuid ~= message.uuid then
    return
  end
  self.digGameInfo.rewardState = message.rewardState
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameRedUpdate)
end

function AllyDrillDataManager:UpdateDigOnGetReward(message)
  if not self.digGameInfo or self.digGameInfo.uuid ~= message.uuid then
    return
  end
  self.digGameInfo.rewardState = 2
  EventManager:GetInstance():Broadcast(EventId.OnAllyDrillInfoRefresh)
  EventManager:GetInstance():Broadcast(EventId.DiggingGameRedUpdate)
end

return AllyDrillDataManager
