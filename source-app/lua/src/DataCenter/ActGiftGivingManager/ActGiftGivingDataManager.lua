local ActGiftGivingDataManager = BaseClass("ActGiftGivingDataManager")
local Localization = CS.GameEntry.Localization
local ActGiftGivingData = require("DataCenter.ActGiftGivingManager.ActGiftGivingData")
local ActivityThanksgivingTemplate = require("DataCenter.ActGiftGivingManager.ActivityThanksgivingTemplate")
local ActGiftGivingAutoSendSaveKey = "ActGiftGivingAutoSend"

local function __init(self)
  self.dataDict = {}
  self.templatepDict = {}
  self.autoSendSaveDict = {}
  self.worldRewardBubbleMaxNum = 0
  self.worldRewardBubbleTargetActId = 0
  self.worldRewardBubbleMaxNumDataDirty = true
  self.thanksgiving_times = {}
  self.thanksgiving_times_expire = 0
  self.targetActId = 0
  self.targetActEndTime = 0
  self.targetActIdNeedRefresh = true
end

local function __delete(self)
  self.dataDict = nil
  self.templatepDict = nil
  self.autoSendSaveDict = nil
  self.worldRewardBubbleMaxNum = nil
  self.worldRewardBubbleMaxNumDataDirty = nil
  self.thanksgiving_times = nil
  self.thanksgiving_times_expire = nil
end

local function RefreshActDetailData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActGiftGivingData.New()
  end
  self.dataDict[activityId]:ParseData(message)
  self.targetActIdNeedRefresh = true
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
  return num, 0, 0
end

local function GetTemplate(self, templateId)
  local template
  if self.templatepDict[templateId] == nil then
    self.templatepDict[templateId] = ActivityThanksgivingTemplate.New()
    local cfg = LocalController:instance():getLine(TableName.Activity_Thanksgiving, templateId)
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

local function GetTempByActId(self, actId)
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
  local subType = tonumber(tabData.tableInfoType)
  local templateId = subType
  local template = self:GetTemplate(templateId)
  return template
end

local function GetIsAutoSend(self, actId)
  if self.autoSendSaveDict[actId] == nil then
    local keyName = ActGiftGivingAutoSendSaveKey .. actId .. "_" .. LuaEntry.Player.uid
    self.autoSendSaveDict[actId] = Setting:GetBool(keyName, false)
  end
  local ret = self.autoSendSaveDict[actId]
  return ret
end

local function SetIsAutoSend(self, actId, isAutoSend)
  self.autoSendSaveDict[actId] = isAutoSend
  local keyName = ActGiftGivingAutoSendSaveKey .. actId .. "_" .. LuaEntry.Player.uid
  Setting:SetBool(keyName, isAutoSend)
end

local function GetRewardTargetIndex(self, actId)
  local targetIndex = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if activityInfo == nil then
    return targetIndex
  end
  local activityDetailData = self:GetActData(actId)
  if activityDetailData == nil then
    return targetIndex
  end
  local activityTemp = self:GetTempByActInfo(activityInfo)
  if activityTemp == nil then
    return targetIndex
  end
  local curNum = activityDetailData.totalAmount
  local receiveDict = activityDetailData.receiveDict
  local rewardIndexData = activityTemp.thxgiv_acc_tab
  for i, v in ipairs(rewardIndexData) do
    if #v == 3 then
      local targetNum = v[1]
      if curNum >= targetNum and not receiveDict[i - 1] then
        targetIndex = i
        break
      end
    end
  end
  return targetIndex
end

local function ReceiveGiveRewardeMsg(self, message)
  local activityId = message.activityId
  local activityDetailData = self:GetActData(activityId)
  if activityDetailData == nil then
    return
  end
  activityDetailData:ReceiveGiveRewardeMsg(message)
end

local function ReceiveRecommendeMsg(self, message)
  local activityId = message.activityId
  local activityDetailData = self:GetActData(activityId)
  if activityDetailData == nil then
    return
  end
  activityDetailData:ReceiveRecommendeMsg(message)
end

local function GetWorldRewardBubbleMaxNum(self)
  if self.worldRewardBubbleMaxNumDataDirty then
    self.worldRewardBubbleMaxNumDataDirty = false
    local targetActId = 0
    for k, v in pairs(self.dataDict) do
      targetActId = k
      break
    end
    if 0 < targetActId then
      local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(targetActId)
      if activityInfo then
        local activityTemp = self:GetTempByActInfo(activityInfo)
        if activityTemp then
          self.worldRewardBubbleMaxNum = activityTemp.day_receive_num
          self.worldRewardBubbleTargetActId = targetActId
        end
      end
    end
  end
  return self.worldRewardBubbleMaxNum
end

function ActGiftGivingDataManager:SetRewardBubbleGetNumData(msg)
  if msg.thanksgiving_times ~= nil then
    for k, v in pairs(msg.thanksgiving_times) do
      for k1, v1 in pairs(v) do
        self.thanksgiving_times[tonumber(k1)] = v1
      end
    end
  end
  if msg.thanksgiving_times_expire ~= nil then
    self.thanksgiving_times_expire = msg.thanksgiving_times_expire
  end
end

function ActGiftGivingDataManager:GetRewardBubbleGetNum()
  local curNum = 0
  local openActId = self:GetOneOpenActId()
  if openActId == 0 then
    return curNum
  end
  if self.thanksgiving_times[openActId] == nil then
    return curNum
  end
  curNum = self.thanksgiving_times[openActId]
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.thanksgiving_times_expire then
    curNum = 0
  end
  return curNum
end

function ActGiftGivingDataManager:GetActivityStatusReceiveDict(statusId, playerUuid)
  return DataCenter.ActivityReceiveDataManager:GetActivityStatusReceiveDict(statusId, playerUuid)
end

function ActGiftGivingDataManager:SetActivityStatusReceiveDictPushMsg(message)
  DataCenter.ActivityReceiveDataManager:SetActivityStatusReceiveDictPushMsg(message)
end

function ActGiftGivingDataManager:InitData(msg)
  self:SetRewardBubbleGetNumData(msg)
end

function ActGiftGivingDataManager:GetOneOpenActId()
  if self.targetActIdNeedRefresh == false then
    if self.targetActId == 0 then
      return self.targetActId, self.targetActEndTime
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.targetActEndTime then
        return self.targetActId, self.targetActEndTime
      else
        self.targetActId = 0
        self.targetActEndTime = 0
      end
    end
  end
  self.targetActIdNeedRefresh = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.targetActEndTime then
    return self.targetActId, self.targetActEndTime
  end
  self.targetActId = 0
  self.targetActEndTime = 0
  for k, v in pairs(self.dataDict) do
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(k)
    if activityInfo and curTime < activityInfo.endTime then
      self.targetActId = k
      self.targetActEndTime = activityInfo.endTime
      break
    end
  end
  return self.targetActId, self.targetActEndTime
end

ActGiftGivingDataManager.__init = __init
ActGiftGivingDataManager.__delete = __delete
ActGiftGivingDataManager.RefreshActDetailData = RefreshActDetailData
ActGiftGivingDataManager.GetActData = GetActData
ActGiftGivingDataManager.GetRedNum = GetRedNum
ActGiftGivingDataManager.GetTemplate = GetTemplate
ActGiftGivingDataManager.GetTempByActInfo = GetTempByActInfo
ActGiftGivingDataManager.GetTempByActId = GetTempByActId
ActGiftGivingDataManager.GetIsAutoSend = GetIsAutoSend
ActGiftGivingDataManager.SetIsAutoSend = SetIsAutoSend
ActGiftGivingDataManager.GetRewardTargetIndex = GetRewardTargetIndex
ActGiftGivingDataManager.ReceiveGiveRewardeMsg = ReceiveGiveRewardeMsg
ActGiftGivingDataManager.ReceiveRecommendeMsg = ReceiveRecommendeMsg
ActGiftGivingDataManager.GetWorldRewardBubbleMaxNum = GetWorldRewardBubbleMaxNum
return ActGiftGivingDataManager
