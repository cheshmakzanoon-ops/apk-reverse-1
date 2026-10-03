local ActLotteryDataManager = BaseClass("ActLotteryDataManager")
local Localization = CS.GameEntry.Localization
local ActLotteryData = require("DataCenter.ActLotteryManager.ActLotteryData")
local ActivityThanksgivingLotteryTemplate = require("DataCenter.ActLotteryManager.ActivityThanksgivingLotteryTemplate")
local ActLotterySkipBtnKeyStr = "ActLotterySkipBtnKey"

local function __init(self)
  self.dataDict = {}
  self.templatepDict = {}
  self.openBigRewardState = ActLotteryOpenBigRewardState.CanCheck
  self.openBigRewardStateTime = 0
  self.pushNoticActId = 0
  self.pushNoticActIdTime = 0
end

local function __delete(self)
  self.dataDict = nil
  self.templatepDict = nil
  self.openBigRewardState = nil
  self.openBigRewardStateTime = nil
  self.pushNoticActId = nil
  self.pushNoticActIdTime = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActLotteryData.New()
  end
  self.dataDict[activityId]:ParseData(message)
end

local function RefreshGetActRewardData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:RefreshGetActRewardData(message)
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function GetRedNum(self, actId)
  local num = 0
  if self.dataDict[actId] then
    num = self.dataDict[actId]:GetRedNum()
  end
  return num
end

local function GetTemplate(self, templateId)
  local template
  if self.templatepDict[templateId] == nil then
    self.templatepDict[templateId] = ActivityThanksgivingLotteryTemplate.New()
    local cfg = LocalController:instance():getLine(TableName.Activity_Thanksgiving_Lottery, templateId)
    if cfg then
      self.templatepDict[templateId]:InitConfig(cfg)
    end
  end
  template = self.templatepDict[templateId]
  return template
end

local function GetTempByActInfo(self, activityInfo)
  local templateId = activityInfo.subType
  local template = self:GetTemplate(templateId)
  return template
end

local function GetIsSkip(self)
  local keyName = ActLotterySkipBtnKeyStr .. LuaEntry.Player.uid
  local isSkip = Setting:GetInt(keyName, 0)
  return isSkip
end

local function SetIsSkip(self, isSkip)
  local keyName = ActLotterySkipBtnKeyStr .. LuaEntry.Player.uid
  Setting:SetInt(keyName, isSkip)
end

local function GetDrawNumByType(self, drawType)
  local num = 0
  if drawType == ActLotteryDrawType.One then
    num = 1
  elseif drawType == ActLotteryDrawType.Ten then
    num = 10
  elseif drawType == ActLotteryDrawType.Hundred then
    num = 100
  end
  return num
end

local function GetNextOpenRewardTimeAndDayNum(self, activityId)
  local openTime = 0
  local dayNum = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = self.dataDict[activityId]
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if data and activityInfo then
    local actEndTime = activityInfo.endTime
    dayNum = data.lastOpenDay + 1
    openTime = data.firstSettlementTime + (dayNum - 1) * 86400
    if actEndTime < openTime then
      openTime = 0
      dayNum = 0
    end
  end
  return openTime, dayNum
end

local function SetTicketHistory(self, message)
  local activityId = message.activityId
  local data = self.dataDict[activityId]
  if data then
    data:SetTicketHistory(message)
  end
end

local function SetOwnerRecord(self, message)
  local activityId = message.activityId
  local data = self.dataDict[activityId]
  if data then
    data:SetOwnerRecord(message)
  end
end

local function SetGiveLogs(self, message)
  local activityId = message.activityId
  local data = self.dataDict[activityId]
  if data then
    data:SetGiveLogs(message)
  end
end

local function GetOpenMsg(self, message)
  local activityId = message.activityId
  local data = self.dataDict[activityId]
  if data then
    data:GetOpenMsg(message)
  end
end

local function GetReceiveBigRewardMsg(self, message)
  local activityId = message.activityId
  local data = self.dataDict[activityId]
  if data then
    data:GetReceiveBigRewardMsg(message)
  end
end

local function CanCheckOpenBigReward(self)
  local result = false
  if self.openBigRewardState == ActLotteryOpenBigRewardState.CanCheck then
    result = true
  elseif self.openBigRewardState == ActLotteryOpenBigRewardState.WaitMsgReturn then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - self.openBigRewardStateTime > 10000 then
      result = true
    end
  end
  return result
end

local function SendOpenBigRewardMsg(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.openBigRewardState = ActLotteryOpenBigRewardState.WaitMsgReturn
  self.openBigRewardStateTime = curTime
end

local function GetOpenBigRewardMsg(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.openBigRewardState = ActLotteryOpenBigRewardState.WaitViewClose
  self.openBigRewardStateTime = curTime
end

local function GetOpenBigRewardViewClose(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.openBigRewardState = ActLotteryOpenBigRewardState.CanCheck
  self.openBigRewardStateTime = curTime
end

local function GetLotteryRankName(self, rank, isWin)
  local name = ""
  if isWin then
    name = Localization:GetString("thxgiv_Lottery_bigWin")
  elseif rank == 1 then
    name = Localization:GetString("thxgiv_Lottery_first")
  elseif rank == 2 then
    name = Localization:GetString("thxgiv_Lottery_second")
  elseif rank == 3 then
    name = Localization:GetString("thxgiv_Lottery_third")
  end
  return name
end

function ActLotteryDataManager:GetRewardDataById(rewardId)
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = nums[i] or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
  end
  return res
end

function ActLotteryDataManager:GetLotteryOpenTime(time)
  local str = ""
  local format = UITimeManager:GetInstance():TimeStampToServerDate(time)
  str = string.format("%d-%d", format.month, format.day)
  return str
end

function ActLotteryDataManager:GetLotteryOpenTimeByDayNum(activityId, dayNum)
  local str = ""
  local data = self.dataDict[activityId]
  if data then
    local firstSettlementTime = data.firstSettlementTime
    local openTime = firstSettlementTime + (dayNum - 1) * 86400
    str = self:GetLotteryOpenTime(openTime * 1000)
  end
  return str
end

function ActLotteryDataManager:GetRealBigRewardTimeData(activityId)
  local curDayNum = 0
  local nextOpenTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = self.dataDict[activityId]
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if data and activityInfo then
    local actEndTime = activityInfo.endTime
    if curTime < data.firstSettlementTime * 1000 then
      curDayNum = 0
      nextOpenTime = data.firstSettlementTime * 1000
    else
      curDayNum = 1 + math.floor((curTime - data.firstSettlementTime * 1000) / 86400000)
      nextOpenTime = (data.firstSettlementTime + curDayNum * 86400) * 1000
      if actEndTime < nextOpenTime then
        nextOpenTime = 0
      end
    end
  end
  return curDayNum, nextOpenTime
end

function ActLotteryDataManager:TryPushNotice()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local oldActId = self.pushNoticActId
  local oldActIdTime = self.pushNoticActIdTime
  local isActOpen = false
  if self.pushNoticActId > 0 then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.pushNoticActId)
    if activityInfo and curTime < activityInfo.endTime then
      isActOpen = true
    end
  end
  if isActOpen == false then
    self.pushNoticActId = 0
    self.pushNoticActIdTime = 0
    for k, v in pairs(self.dataDict) do
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(k)
      if activityInfo and curTime < activityInfo.endTime then
        self.pushNoticActId = k
        self.pushNoticActIdTime = 0
        break
      end
    end
  end
  if self.pushNoticActId > 0 then
    local curDayNumReal, nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.pushNoticActId)
    self.pushNoticActIdTime = nextOpenTimeReal
  end
  EventManager:GetInstance():Broadcast(EventId.ActLotteryTryOpenTip)
end

ActLotteryDataManager.__init = __init
ActLotteryDataManager.__delete = __delete
ActLotteryDataManager.RefreshActDetailData = RefreshActDetailData
ActLotteryDataManager.GetActData = GetActData
ActLotteryDataManager.GetRedNum = GetRedNum
ActLotteryDataManager.GetTemplate = GetTemplate
ActLotteryDataManager.GetTempByActInfo = GetTempByActInfo
ActLotteryDataManager.RefreshGetActRewardData = RefreshGetActRewardData
ActLotteryDataManager.GetIsSkip = GetIsSkip
ActLotteryDataManager.SetIsSkip = SetIsSkip
ActLotteryDataManager.GetDrawNumByType = GetDrawNumByType
ActLotteryDataManager.GetNextOpenRewardTimeAndDayNum = GetNextOpenRewardTimeAndDayNum
ActLotteryDataManager.SetTicketHistory = SetTicketHistory
ActLotteryDataManager.SetOwnerRecord = SetOwnerRecord
ActLotteryDataManager.SetGiveLogs = SetGiveLogs
ActLotteryDataManager.GetOpenMsg = GetOpenMsg
ActLotteryDataManager.GetReceiveBigRewardMsg = GetReceiveBigRewardMsg
ActLotteryDataManager.CanCheckOpenBigReward = CanCheckOpenBigReward
ActLotteryDataManager.SendOpenBigRewardMsg = SendOpenBigRewardMsg
ActLotteryDataManager.GetOpenBigRewardMsg = GetOpenBigRewardMsg
ActLotteryDataManager.GetOpenBigRewardViewClose = GetOpenBigRewardViewClose
ActLotteryDataManager.GetLotteryRankName = GetLotteryRankName
return ActLotteryDataManager
