local ActLotteryData = BaseClass("ActLotteryData")
local dataExpiredTime = 10

local function __init(self)
  self.activityId = 0
  self.reward = {}
  self.firstSettlementTime = 0
  self.lastOpenDay = 0
  self.ticketHistory = {}
  self.ticketHistoryExpiredTime = 0
  self.ownerRecord = {}
  self.ownerRecordExpiredTime = 0
  self.giveLogs = {}
  self.giveLogsTotalNum = 0
  self.giveLogsExpiredTime = 0
end

local function __delete(self)
  self.activityId = nil
  self.reward = nil
  self.firstSettlementTime = nil
  self.lastOpenDay = nil
  self.ticketHistory = nil
  self.ticketHistoryExpiredTime = nil
  self.ownerRecord = nil
  self.ownerRecordExpiredTime = nil
  self.giveLogs = nil
  self.giveLogsTotalNum = nil
  self.giveLogsExpiredTime = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.reward ~= nil then
    self.reward = message.reward
  end
  if message.firstSettlementTime ~= nil then
    self.firstSettlementTime = message.firstSettlementTime
  end
  if message.lastOpenDay ~= nil then
    self.lastOpenDay = message.lastOpenDay
  end
end

local function GetRedNum(self)
  local num = 0
  return num
end

local function RefreshGetActRewardData(self)
  self.reward = {}
end

local function SetTicketHistory(self, message)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.ticketHistory = message.playerArr
  self.ticketHistoryExpiredTime = curTime + dataExpiredTime * 1000
end

local function CheckNeedReqTicketHistory(self)
  local curDayNumReal, nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
  local TicketHistory = self.ticketHistory
  local isNeed = true
  if 0 < curDayNumReal then
    if self.ticketHistory ~= nil then
      for k, v in ipairs(TicketHistory) do
        if v.dayNum == curDayNumReal then
          isNeed = false
          break
        end
      end
    else
    end
  else
    isNeed = false
  end
  return isNeed
end

local function GetTicketHistory(self)
  return self.ticketHistory
end

local function CheckTicketHistoryExpired(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.ticketHistoryExpiredTime then
    return true
  end
  return false
end

local function SetOwnerRecord(self, message)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.ownerRecord = message.historyArr
  self.ownerRecordExpiredTime = curTime + dataExpiredTime * 1000
end

local function GetOwnerRecord(self)
  return self.ownerRecord
end

local function CheckOwnerRecordExpired(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.ownerRecordExpiredTime then
    return true
  end
  return false
end

local function SetGiveLogs(self, message)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local start = message.start
  if start == 1 then
    self.giveLogs = message.giveRecordArr
  elseif start == #self.giveLogs + 1 then
    for k, v in ipairs(message.giveRecordArr) do
      table.insert(self.giveLogs, v)
    end
  end
  self.giveLogsTotalNum = message.totalNum
  self.giveLogsExpiredTime = curTime + 3000
end

local function GetGiveLogs(self)
  return self.giveLogs
end

local function CheckGiveLogsExpired(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.giveLogsExpiredTime then
    return true
  end
  return false
end

local function GetOpenMsg(self, message)
  if message.win and message.win == 0 then
    self.lastOpenDay = message.day
  end
end

local function GetReceiveBigRewardMsg(self, message)
  self.lastOpenDay = message.day
end

ActLotteryData.__init = __init
ActLotteryData.__delete = __delete
ActLotteryData.ParseData = ParseData
ActLotteryData.GetRedNum = GetRedNum
ActLotteryData.RefreshGetActRewardData = RefreshGetActRewardData
ActLotteryData.SetTicketHistory = SetTicketHistory
ActLotteryData.GetTicketHistory = GetTicketHistory
ActLotteryData.CheckTicketHistoryExpired = CheckTicketHistoryExpired
ActLotteryData.SetOwnerRecord = SetOwnerRecord
ActLotteryData.GetOwnerRecord = GetOwnerRecord
ActLotteryData.CheckOwnerRecordExpired = CheckOwnerRecordExpired
ActLotteryData.SetGiveLogs = SetGiveLogs
ActLotteryData.GetGiveLogs = GetGiveLogs
ActLotteryData.CheckGiveLogsExpired = CheckGiveLogsExpired
ActLotteryData.GetOpenMsg = GetOpenMsg
ActLotteryData.GetReceiveBigRewardMsg = GetReceiveBigRewardMsg
ActLotteryData.CheckNeedReqTicketHistory = CheckNeedReqTicketHistory
return ActLotteryData
