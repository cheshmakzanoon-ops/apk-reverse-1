local SeasonMilitaryInfoData = require("UI.LWSeason6.UILWSeasonMilitary.Main.SeasonMilitaryInfoData")
local LwSeasonMilitaryLevelTemplate = require("UI.LWSeason6.UILWSeasonMilitary.Main.LwSeasonMilitaryLevelTemplate")
local SeasonMilitaryManager = BaseClass("SeasonMilitaryManager")

function SeasonMilitaryManager:__init()
  self:InitVars()
end

function SeasonMilitaryManager:InitVars()
  self.LOG_ENABLE = true
  self.ActId = 0
  self.ActCell = nil
  self.ActState = {Normal = 1, EndShow = 2}
  self.TrendSettlementState = {Rank = 1, Settlement = 2}
  self.InitClaimNum = 0
  self.InitClaimNumUpdateTime = 0
  self.MaxManualLevelCell = nil
  self.InfoData = nil
  self.LevelCells = {}
  self.LevelCellGroupMap = {}
  self.WaitingGetRoyal = {}
  self.CacheRoyalData = {}
  self.WaitingGetTrendSettlement = false
  self.CacheTrendSettlementData = {}
  self.AnimLevel = -1
  self.LastToggleTime = -1
end

function SeasonMilitaryManager:__delete()
  self.ActId = 0
  self.ActCell = nil
  self.InfoData = nil
  self.LevelCells = {}
  self.LevelCellGroupMap = {}
end

function SeasonMilitaryManager:OnInitMessage(payload)
  self.InitClaimNum = checknumber(payload.military_daily_reward)
  self.InitClaimNumUpdateTime = UITimeManager:GetInstance():GetServerTime()
end

function SeasonMilitaryManager:SetActId(actId)
  self.ActId = actId
  self.ActCell = LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
end

function SeasonMilitaryManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonMilitaryManager:GetCurActState()
  local endShowStartTime = self:GetEndShowStartTime()
  if endShowStartTime > UITimeManager:GetInstance():GetServerTime() then
    return self.ActState.Normal
  end
  return self.ActState.EndShow
end

function SeasonMilitaryManager:ShowRedCount()
  local count = 0
  if self:ShowDailyRed() then
    count = count + 1
  end
  if self:ShowUpgradeRed() then
    count = count + 1
  end
  return count
end

function SeasonMilitaryManager:ShowDailyRed()
  return self.InfoData ~= nil and self.InfoData:CanClaim()
end

function SeasonMilitaryManager:ShowUpgradeRed()
  if self.InfoData == nil or self.InfoData.IsSettleIng then
    return false
  end
  if self:GetCurActState() ~= self.ActState.Normal then
    return false
  end
  local curLevel = self.InfoData:GetLevel()
  if not self:CanManualUpgrade(curLevel) then
    return false
  end
  local nextLevelCell = self:GetLevelCellTmp(curLevel + 1)
  if nextLevelCell == nil then
    return false
  end
  if checknumber(nextLevelCell.need_rank) ~= 0 then
    return false
  end
  local scoreValid = self.InfoData:GetScore() >= checknumber(nextLevelCell.unlock_score)
  if not scoreValid then
    return false
  end
  local taskType = checknumber(nextLevelCell.unlock_condition_type)
  if 0 < taskType then
    local taskValid = self.InfoData:GetTaskValue(taskType) >= checknumber(nextLevelCell.unlock_condition_para)
    if not taskValid then
      return false
    end
  end
  return true
end

function SeasonMilitaryManager:GetMilitaryItemId()
  local actData = self:GetActData()
  if actData ~= nil then
    return checknumber(actData.para)
  end
  return 0
end

function SeasonMilitaryManager:GetEndShowStartTime()
  local actData = self:GetActData()
  if actData ~= nil then
    local startTime = actData:GetShowStartTime()
    if self.ActCell ~= nil then
      local normalDay = checknumber(self.ActCell.para_1)
      return startTime + normalDay * 24 * 3600 * 1000
    end
  end
  return 0
end

function SeasonMilitaryManager:GetTrendSettlementState()
  local settlementTime = self:GetTrendSettlementTime()
  if settlementTime > UITimeManager:GetInstance():GetServerTime() then
    return self.TrendSettlementState.Rank
  end
  return self.TrendSettlementState.Settlement
end

function SeasonMilitaryManager:GetTrendSettlementTime()
  local actData = self:GetActData()
  if actData ~= nil then
    local startTime = actData:GetShowStartTime()
    if self.ActCell ~= nil then
      local normalDay = checknumber(self.ActCell.para_6)
      return startTime + normalDay * 24 * 3600 * 1000
    end
  end
  return 0
end

function SeasonMilitaryManager:GetMainItemEndShowTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local normalEndTime = self:GetEndShowStartTime()
  if now < normalEndTime then
    return normalEndTime
  end
  local actData = self:GetActData()
  if actData ~= nil then
    return actData:GetShowEndTime()
  end
  return 0
end

function SeasonMilitaryManager:GetNextAutoUpgradeTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  return self:CalculateNextSettlementTime(now)
end

function SeasonMilitaryManager:CalculateNextSettlementTime(baseTime)
  local actData = self:GetActData()
  if actData ~= nil then
    local autoTime = actData.para_4
    local weekDayArr = string.string2array_i_oneSep(autoTime, "|")
    if not table.IsNullOrEmpty(weekDayArr) then
      do
        local function getNextTime(weekZero, targetTime)
          local time = 0
          
          local maxTime = DataCenter.SeasonMilitaryManager:GetEndShowStartTime()
          for _, weekDay in pairs(weekDayArr) do
            time = weekZero + (checknumber(weekDay) - 1) * OneDayTime * SecToMilSec
            if maxTime <= time then
              return -1
            end
            if targetTime < time then
              return time
            end
          end
          return -1
        end
        
        local nowWeekZero = UITimeManager:GetInstance():WeekZero(baseTime)
        local nextTime = getNextTime(nowWeekZero, baseTime)
        if nextTime < 0 then
          local nextWeekZero = nowWeekZero + 7 * OneDayTime * 1000
          nextTime = getNextTime(nextWeekZero, baseTime)
        end
        return nextTime
      end
    end
  end
  return 0
end

function SeasonMilitaryManager:IsSameSettlementCycle(targetTime)
  if checknumber(targetTime) == 0 then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local nextSettlementOfTarget = self:CalculateNextSettlementTime(targetTime)
  local nextSettlementOfNow = self:CalculateNextSettlementTime(now)
  return nextSettlementOfTarget == nextSettlementOfNow
end

function SeasonMilitaryManager:GenLevelConfigCells()
  self.LevelCells = {}
  self.LevelCellGroupMap = {}
  if self.ActCell ~= nil then
    local group = checknumber(self.ActCell.para_2)
    LocalController:instance():visitTable(TableName.LW_SEASON_MILITARY_LEVEL, function(id, _cell)
      if checknumber(_cell.group) == group then
        local template = LwSeasonMilitaryLevelTemplate.New()
        template:UpdateData(_cell)
        self.LevelCells[checknumber(template.level)] = template
        local levelGroup = checknumber(template.level_group)
        if self.LevelCellGroupMap[levelGroup] == nil then
          self.LevelCellGroupMap[levelGroup] = {}
        end
        table.insert(self.LevelCellGroupMap[levelGroup], template)
      end
    end)
    for _, cells in pairs(self.LevelCellGroupMap) do
      table.sort(cells, function(a, b)
        return checknumber(a.level) < checknumber(b.level)
      end)
    end
  end
end

function SeasonMilitaryManager:GetLevelCells()
  if table.IsNullOrEmpty(self.LevelCells) then
    self:GenLevelConfigCells()
  end
  return self.LevelCells
end

function SeasonMilitaryManager:GetLevelCellGroupMap()
  if table.IsNullOrEmpty(self.LevelCellGroupMap) then
    self:GenLevelConfigCells()
  end
  return self.LevelCellGroupMap
end

function SeasonMilitaryManager:GetLevelCellTmp(level)
  level = checknumber(level)
  local levelCells = self:GetLevelCells()
  return levelCells[level]
end

function SeasonMilitaryManager:GetLevelStarNum(level)
  level = checknumber(level)
  local curCell = self:GetLevelCellTmp(level)
  if curCell ~= nil then
    local levelCellGroupMap = self:GetLevelCellGroupMap()
    local cells = levelCellGroupMap[checknumber(curCell.level_group)]
    local firstCell = table.getFirst(cells)
    if firstCell ~= nil then
      local curNum = checknumber(curCell.level) - checknumber(firstCell.level) + 1
      local totalNum = table.count(cells)
      if totalNum == 1 then
        totalNum = 0
        curNum = 0
      end
      return curNum, totalNum
    end
  end
  return 0, 0
end

function SeasonMilitaryManager:HasPreLevel(level)
  level = checknumber(level)
  return self:GetLevelCellTmp(level - 1) ~= nil
end

function SeasonMilitaryManager:HasNextLevel(level)
  level = checknumber(level)
  return self:GetLevelCellTmp(level + 1) ~= nil
end

function SeasonMilitaryManager:GetCurLevel()
  if self.InfoData ~= nil then
    return self.InfoData:GetLevel()
  end
  return 0
end

function SeasonMilitaryManager:GetCurLevelStatusList()
  if self.InfoData ~= nil then
    local curLevelCell = self.InfoData.Cell
    if curLevelCell ~= nil then
      local status = checknumber(curLevelCell:GetStatus())
      if LuaEntry.Effect:HasStatus(status) then
        return {status}
      end
    end
  end
  return {}
end

function SeasonMilitaryManager:GetMaxLevel()
  local cells = self:GetLevelCells()
  return table.count(cells)
end

function SeasonMilitaryManager:GetMaxManualLevelCell()
  if self.MaxManualLevelCell == nil then
    local cells = self:GetLevelCells()
    for _, cell in pairs(cells) do
      if checknumber(cell.standard_level) == 1 then
        self.MaxManualLevelCell = cell
        break
      end
    end
  end
  return self.MaxManualLevelCell
end

function SeasonMilitaryManager:GetMaxManualLevel()
  local cell = self:GetMaxManualLevelCell()
  if cell ~= nil then
    return checknumber(cell.level)
  end
  return 0
end

function SeasonMilitaryManager:CanManualUpgrade(level)
  level = checknumber(level)
  local maxManualLevel = self:GetMaxManualLevel()
  return self:HasNextLevel(level) and level < maxManualLevel
end

function SeasonMilitaryManager:SendGetInfo()
  if self.InfoData == nil then
    self.InfoData = SeasonMilitaryInfoData.New()
  end
  SFSNetwork.SendMessage(MsgDefines.MilitaryActInfo)
end

function SeasonMilitaryManager:OnGetInfoCallback(payload)
  if self.InfoData == nil then
    self.InfoData = SeasonMilitaryInfoData.New()
  end
  self.InfoData:HandleInfo(payload)
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryInfoUpdate)
end

function SeasonMilitaryManager:SendClaimDaily(level)
  local param = {}
  param.level = checknumber(level)
  SFSNetwork.SendMessage(MsgDefines.MilitaryGetDailyReward, param)
end

function SeasonMilitaryManager:OnClaimDailyCallback(payload)
  if payload ~= nil then
    DataCenter.RewardManager:ShowCommonReward(payload)
    if self.InfoData ~= nil then
      self.InfoData:HandleClaimNum(payload.dailyRewardNum)
    end
    if not table.IsNullOrEmpty(payload.reward) then
      DataCenter.RewardManager:AddRewardsAndRes({
        reward = payload.reward
      })
    end
    EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryClaimDaily, payload)
  end
end

function SeasonMilitaryManager:SendLevelUp(level)
  local param = {}
  param.level = checknumber(level)
  SFSNetwork.SendMessage(MsgDefines.MilitaryUpLevel, param)
end

function SeasonMilitaryManager:OnLevelUpCallback(payload)
  if payload ~= nil and self.InfoData ~= nil then
    self.InfoData:HandleLevelUp(payload)
    EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryLevelUpUpdate, payload)
  end
end

function SeasonMilitaryManager:SendGetRoyal(level)
  level = checknumber(level)
  if level <= 1 then
    self:Log("\228\184\141\229\143\175\228\187\165\230\159\165\231\156\139\231\173\137\231\186\167\229\176\143\228\186\142\231\173\137\228\186\1421\231\154\132\229\134\155\232\161\148\230\166\156")
    return
  end
  if self.WaitingGetRoyal[level] then
    return
  end
  self.WaitingGetRoyal[level] = true
  local param = {}
  param.viewLevel = checknumber(level)
  SFSNetwork.SendMessage(MsgDefines.MilitaryFirstLevelListView, param)
end

function SeasonMilitaryManager:OnRoralCallback(payload)
  if payload == nil then
    return
  end
  local level = checknumber(payload.viewLevel)
  self.WaitingGetRoyal[level] = false
  local rankData = {}
  rankData.Payload = payload
  rankData.Level = checknumber(payload.viewLevel)
  rankData.CampId = checknumber(payload.campId)
  rankData.RankList = {}
  if not table.IsNullOrEmpty(payload.userRankRecordArr) then
    local rank = 1
    for _, slot in pairs(payload.userRankRecordArr) do
      local rankSlot = {}
      rankSlot.Uid = slot.uid
      rankSlot.Rank = rank
      rankSlot.MilitaryNum = checknumber(slot.militaryNum)
      rankSlot.RefreshTime = checknumber(slot.refreshTime)
      rankSlot.UserInfo = PlayerRankData.New()
      rankSlot.UserInfo:ParseData(slot.userInfo)
      rankSlot.UserInfo:SetRank(rank)
      table.insert(rankData.RankList, rankSlot)
      rank = rank + 1
    end
  end
  self.CacheRoyalData[level] = rankData
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryLevelRoyalUpdate, rankData)
end

function SeasonMilitaryManager:GetRoyalCacheData(level)
  return self.CacheRoyalData[level]
end

function SeasonMilitaryManager:ClearRoyalCache()
  self.WaitingGetRoyal = {}
  self.CacheRoyalData = {}
end

function SeasonMilitaryManager:SendGetTrendSettlement()
  if self.WaitingGetTrendSettlement then
    return
  end
  self.WaitingGetTrendSettlement = true
  SFSNetwork.SendMessage(MsgDefines.MilitarySettleTradeView)
end

function SeasonMilitaryManager:OnTrendSettlementCallback(payload)
  self.WaitingGetTrendSettlement = false
  if payload == nil then
    return
  end
  self.CacheTrendSettlementData = {}
  if not table.IsNullOrEmpty(payload.militaryTradeRecordArr) then
    for _, record in pairs(payload.militaryTradeRecordArr) do
      record.UserInfo = PlayerRankData.New()
      record.UserInfo:ParseData(record.shareUserInfo)
      table.insert(self.CacheTrendSettlementData, record)
    end
    table.sort(self.CacheTrendSettlementData, function(a, b)
      return a.rank < b.rank
    end)
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryTrendSettlementUpdate, payload)
end

function SeasonMilitaryManager:GetCacheTrendSettlementData()
  return self.CacheTrendSettlementData
end

function SeasonMilitaryManager:ClearTrendSettlementCache()
  self.WaitingGetTrendSettlement = false
  self.CacheTrendSettlementData = {}
end

function SeasonMilitaryManager:Log(desc, ...)
  if self.LOG_ENABLE and CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    local msg = string.format(desc, ...)
    Logger.LogError(string.format("[\229\134\155\232\161\148] %s", msg))
  end
end

return SeasonMilitaryManager
