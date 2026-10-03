local SeasonGoldenTreePhaseThirdTemplate = require("DataCenter.SeasonGoldTreeThird.SeasonGoldenTreePhaseThirdTemplate")
local SeasonGoldTreeThirdManager = BaseClass("SeasonGoldTreeThirdManager")

function SeasonGoldTreeThirdManager:__init()
  self.allianceWeekGoldTreeInfo = nil
  self.historyInfo = {}
  self.configs = {}
end

function SeasonGoldTreeThirdManager:__delete()
  self.allianceWeekGoldTreeInfo = nil
  self.historyInfo = nil
  self.configs = nil
end

function SeasonGoldTreeThirdManager:InitData(data)
  self.activityId = data.id
end

function SeasonGoldTreeThirdManager:GoldTreeBuyLotteryMessage(t)
  DataCenter.SeasonGoldTreeManager:GoldTreeActViewMessage(nil, t.userGoldTreeDataInfo)
  self:RequestGoldTreeGetAllianceCardView(true)
  EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdBuyLottery)
end

function SeasonGoldTreeThirdManager:GoldTreeHideNameMessage(t)
  DataCenter.SeasonGoldTreeManager:GoldTreeActViewMessage(nil, t.userGoldTreeDataInfo)
  self:RequestGoldTreeGetAllianceCardView(true)
  EventManager:GetInstance():Broadcast(EventId.GoldTreeTreeHideName)
end

function SeasonGoldTreeThirdManager:GoldTreeGetAllianceCardViewMessage(t)
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  local curWeek = DataCenter.SeasonGoldTreeThirdManager:GetPrayWeek()
  local weekIndex = (userGoldTreeInfo.weekTime - t.weekTime) / (7 * OneDayTime * 1000)
  if weekIndex == 0 then
    self.allianceWeekGoldTreeInfo = t
    EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdGetCardData)
  end
  if self:GetIsWeekEnd() then
    weekIndex = weekIndex + 1
  end
  if weekIndex ~= 0 then
    self.historyInfo[curWeek - weekIndex + 1] = t
  end
  EventManager:GetInstance():Broadcast(EventId.GoldTreeThirdGetCardData)
end

function SeasonGoldTreeThirdManager:RequestGoldTreeGetAllianceCardView(current, curWeekIndex, index)
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  if current then
    SFSNetwork.SendMessage(MsgDefines.GoldTreeGetAllianceCardView, userGoldTreeInfo.weekTime)
  else
    local data = self.historyInfo[curWeekIndex]
    if data ~= nil then
      return data
    end
    local historyWeekTime = userGoldTreeInfo.weekTime - index * 7 * OneDayTime * 1000
    SFSNetwork.SendMessage(MsgDefines.GoldTreeGetAllianceCardView, historyWeekTime)
  end
end

function SeasonGoldTreeThirdManager:RequestGoldTreeBuyLottery(limit)
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GoldTreeBuyLottery, userGoldTreeInfo.weekTime, limit)
end

function SeasonGoldTreeThirdManager:RequestGoldTreeHideName(hide)
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GoldTreeHideName, userGoldTreeInfo.weekTime, hide)
end

function SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  local treeId = seasonConfig and seasonConfig.golden_tree_phase_third
  if treeId == nil then
    return
  end
  if self.configs[treeId] ~= nil then
    return self.configs[treeId]
  end
  local line = LocalController:instance():getLine(TableName.SEASON_GOLDEN_TREE_THIRD, treeId)
  local template = SeasonGoldenTreePhaseThirdTemplate.New(line)
  template:InitData(line)
  self.configs[treeId] = template
  return template
end

function SeasonGoldTreeThirdManager:Active()
  local config = self:GetGoldTreeThirdConfig()
  if config == nil then
    return false
  end
  return config:IsStart()
end

function SeasonGoldTreeThirdManager:GetNpcNextRewardData()
  local config = self:GetGoldTreeThirdConfig()
  return config:GetNpcNextRewardData(self:GetBuyLotteryCount())
end

function SeasonGoldTreeThirdManager:GetBuyLotteryCount()
  if self.allianceWeekGoldTreeInfo == nil then
    return 0
  end
  return self.allianceWeekGoldTreeInfo.buyNum or 0
end

function SeasonGoldTreeThirdManager:GetAllLotteryRewardCount(opData)
  if opData ~= nil then
    return opData.buyGoldNum + opData.extraNum
  end
  if self.allianceWeekGoldTreeInfo == nil then
    return 0
  end
  return (self.allianceWeekGoldTreeInfo.buyGoldNum or 0) + (self.allianceWeekGoldTreeInfo.extraNum or 0)
end

function SeasonGoldTreeThirdManager:GetPrayWeek()
  local week = DataCenter.SeasonGoldTreeManager:GetPrayWeek()
  week = week - self:GetStartWeek()
  return week
end

function SeasonGoldTreeThirdManager:GetStartWeek()
  local config = self:GetGoldTreeThirdConfig()
  local days = config.start - tonumber(DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("start"))
  return tonumber(days / 7) + 1
end

function SeasonGoldTreeThirdManager:GetCurrentLotteryPoolData(opData)
  local pools = {}
  if opData == nil then
    if self.allianceWeekGoldTreeInfo ~= nil then
      pools = self.allianceWeekGoldTreeInfo.userCardArr or {}
    end
  else
    pools = opData.userCardArr or {}
  end
  local poolTemp = {}
  for _, v in ipairs(pools) do
    local comb = poolTemp[v.combinationId] or {}
    table.insert(comb, v)
    poolTemp[v.combinationId] = comb
  end
  local sortTemp = {}
  for k, v in pairs(poolTemp) do
    local groupConfig = DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(k)
    table.insert(sortTemp, {
      weight = groupConfig.weight,
      combinationId = k,
      data = v
    })
  end
  table.sort(sortTemp, function(a, b)
    return a.weight > b.weight
  end)
  local result = {
    [1] = {
      combinationId = nil,
      isSelf = false,
      list = {}
    },
    [2] = {
      combinationId = nil,
      isSelf = false,
      list = {}
    },
    [3] = {
      combinationId = nil,
      comName = "season_golden_tree_phase_third_UI_38",
      isSelf = false,
      list = {}
    },
    playerCount = 0,
    poolCount = 0,
    allReward = self:GetAllLotteryRewardCount(opData)
  }
  for index = 1, #sortTemp do
    if index == 1 then
      for k, v in ipairs(sortTemp[index].data) do
        table.insert(result[1].list, v)
      end
      result[1].combinationId = sortTemp[index].combinationId
    elseif index == 2 then
      for k, v in ipairs(sortTemp[index].data) do
        table.insert(result[2].list, v)
      end
      result[2].combinationId = sortTemp[index].combinationId
    else
      for k, v in ipairs(sortTemp[index].data) do
        table.insert(result[3].list, v)
      end
    end
  end
  local poolCount, playerCount = 1, 0
  for index = 1, 3 do
    local resultData = result[index]
    if 1 <= #resultData.list then
      if index ~= 1 then
        poolCount = poolCount + 1
      end
      playerCount = playerCount + #resultData.list
    end
    for _, v in ipairs(resultData.list) do
      if v.uid == LuaEntry.Player.uid then
        resultData.isSelf = true
        break
      end
    end
  end
  result.poolCount = poolCount
  result.playerCount = playerCount
  return result
end

function SeasonGoldTreeThirdManager:GetSelfLottery()
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  local config = self:GetGoldTreeThirdConfig()
  local lotteryStageArr = userGoldTreeInfo:GetUserGoldTreeInfo().lotteryStageArr
  local canBuyData
  for _, data in ipairs(config.lotteryData) do
    data.hasBuy = false
    if lotteryStageArr ~= nil then
      for _, limit in pairs(lotteryStageArr) do
        if tonumber(limit) == data.limit then
          data.hasBuy = true
        end
      end
    end
    local curWeekIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
    data.canBuy = curWeekIndex == data.limit
    data.maturity = curWeekIndex > data.limit
    if data.canBuy then
      canBuyData = data
    end
  end
  return config.lotteryData, canBuyData
end

function SeasonGoldTreeThirdManager:GetNameHide()
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  return userGoldTreeInfo:GetUserGoldTreeInfo().lotteryHideName == 1
end

function SeasonGoldTreeThirdManager:GetWeekEndTime()
  return UITimeManager:GetInstance():GetNextWeekDay(1) - 86400000
end

function SeasonGoldTreeThirdManager:GetBugLotteryCount()
  if self.allianceWeekGoldTreeInfo == nil then
    return 0
  end
  return self.allianceWeekGoldTreeInfo.buyNum or 0
end

function SeasonGoldTreeThirdManager:GetHistoryInfoByWeekIndex(weekIndex)
  return self.historyInfo[weekIndex]
end

function SeasonGoldTreeThirdManager:ClearHistoryInfoByWeekIndex()
  return table.clear(self.historyInfo)
end

function SeasonGoldTreeThirdManager:GetGoldTreeBuyLotteryRed()
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return 0
  end
  if 0 < table.count(userGoldTreeInfo.userGoldTeeInfo.lotteryStageArr) then
    return 0
  end
  local config = self:GetGoldTreeThirdConfig()
  if config == nil then
    return 0
  end
  for _, data in ipairs(config.lotteryData) do
    local curWeekIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
    if curWeekIndex == data.limit then
      return 1
    end
  end
  return 0
end

function SeasonGoldTreeThirdManager:GetIsWeekEnd()
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  if not userGoldTreeInfo then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime - userGoldTreeInfo.weekTime >= 518400000
end

return SeasonGoldTreeThirdManager
