local CumulativeRechargeManager = BaseClass("CumulativeRechargeManager")
local RechargeStageInfo = require("DataCenter.CumulativeRechargeManager.RechargeStageInfo")

local function __init(self)
  self.rechargeStage = {}
  self.tempStage = 0
  self.isFirst = true
  self.cacheLastReachStage = {}
end

local function __delete(self)
  self:RemoveTimer()
  self.recharge = nil
  self.isFirst = nil
  self.cacheLastReachStage = nil
end

local function GetReachStage(self, rechargeId, score)
  if self.rechargeStage[rechargeId] then
    local rechargeStage = self.rechargeStage[rechargeId]
    if rechargeStage.stageInfoExtend then
      for i = #rechargeStage.stageInfo + #rechargeStage.stageInfoExtend, #rechargeStage.stageInfo + 1, -1 do
        local index = i - #rechargeStage.stageInfo
        if rechargeStage.stageInfoExtend[index].state == 0 and score >= rechargeStage.stageInfoExtend[index].needScore then
          return i
        end
      end
    end
    for i = #rechargeStage.stageInfo, 1, -1 do
      if rechargeStage.stageInfo[i].state == 0 and score >= rechargeStage.stageInfo[i].needScore then
        return i
      end
    end
  end
  return 0
end

local function InitDat(self, message)
  self.rechargeStage = {}
  if message.rechargeArr then
    local recharge = message.rechargeArr
    for i = 1, #recharge do
      self.rechargeStage[recharge[i].rechargeId] = {}
      self.rechargeStage[recharge[i].rechargeId].score = 0
      self.rechargeStage[recharge[i].rechargeId].endTime = recharge[i].endTime
      self.rechargeStage[recharge[i].rechargeId].rechargeId = recharge[i].rechargeId
      self.rechargeStage[recharge[i].rechargeId].startTime = recharge[i].startTime
      self.rechargeStage[recharge[i].rechargeId].stageInfo = {}
      self.rechargeStage[recharge[i].rechargeId].stageInfoExtend = {}
      self.rechargeStage[recharge[i].rechargeId].nextResetTime = message.nextResetTime or 0
      if self.rechargeStage[recharge[i].rechargeId].endTime and self.rechargeStage[recharge[i].rechargeId].nextResetTime ~= 0 and self.rechargeStage[recharge[i].rechargeId].endTime <= self.rechargeStage[recharge[i].rechargeId].nextResetTime then
        self.rechargeStage[recharge[i].rechargeId].nextResetTime = 0
      end
    end
  end
end

local function RequestDat(self, message)
  for k, v in pairs(self.rechargeStage) do
    SFSNetwork.SendMessage(MsgDefines.GetRechargeInfo, k)
  end
end

local function SendGetRechargeInfo(self, rechargeId)
  SFSNetwork.SendMessage(MsgDefines.GetRechargeInfo, rechargeId)
end

local function UpdateRechargeStageInfo(self, message)
  local rechargeId = message.rechargeId
  if not rechargeId then
    return
  end
  if message.rechargeStageArr then
    if not self.rechargeStage[rechargeId] then
      self.rechargeStage[rechargeId] = {}
    end
    self.rechargeStage[rechargeId].stageInfo = {}
    for i = 1, #message.rechargeStageArr do
      local stageInfo = RechargeStageInfo.New()
      stageInfo:ParseData(message.rechargeStageArr[i])
      table.insert(self.rechargeStage[message.rechargeId].stageInfo, stageInfo)
    end
    local subActivityObj = message.subActivityObj
    if subActivityObj and subActivityObj.subId > 0 and subActivityObj.subStageArr then
      self.rechargeStage[rechargeId].stageInfoExtend = {}
      for i = 1, #subActivityObj.subStageArr do
        local stageInfo = RechargeStageInfo.New()
        stageInfo:ParseData(subActivityObj.subStageArr[i])
        local stageInfoExtend = self.rechargeStage[rechargeId].stageInfoExtend
        table.insert(stageInfoExtend, stageInfo)
      end
      self.rechargeStage[rechargeId].subActivityId = subActivityObj.subId
      self.rechargeStage[rechargeId].subActivityData = self:GetCustomActivityData(subActivityObj)
    end
  end
  self.rechargeStage[rechargeId].score = message.score
  self.rechargeStage[rechargeId].nextResetTime = message.nextResetTime or 0
  if self.rechargeStage[rechargeId].endTime and self.rechargeStage[rechargeId].nextResetTime ~= 0 and self.rechargeStage[rechargeId].endTime <= self.rechargeStage[rechargeId].nextResetTime then
    self.rechargeStage[rechargeId].nextResetTime = 0
  end
  self:CheckAddTimer()
  EventManager:GetInstance():Broadcast(EventId.UpdateAccuRechargeData, rechargeId)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function CumulativeRechargeManager:GetCustomActivityData(messageSubObj)
  local subActivityData = {}
  local activityId = messageSubObj.subId
  subActivityData.id = activityId
  subActivityData.activityId = activityId
  ActivityInfoData.FetchActivityConfigData(subActivityData, activityId)
  subActivityData.startTime = messageSubObj.subBeginTime
  
  function subActivityData.GetRewardChangeGroup()
    return checknumber(subActivityData.reward_change_group)
  end
  
  function subActivityData.GetShowStartTime()
    return subActivityData.startTime
  end
  
  return subActivityData
end

local function PushRechargeScoreHandle(self, message)
  local rechargeId = message.rechargeId
  if rechargeId then
    local prevScore = self.rechargeStage[rechargeId].score
    if prevScore and not self.cacheLastReachStage[rechargeId] then
      self.cacheLastReachStage[rechargeId] = self:GetReachStage(rechargeId, prevScore)
    end
    self.rechargeStage[rechargeId].score = message.score
    EventManager:GetInstance():Broadcast(EventId.RefreshAccuRechargePoint, rechargeId)
    local lastReachStage = self.cacheLastReachStage[rechargeId] or 0
    local curReachStage = self:GetReachStage(rechargeId, message.score)
    if lastReachStage ~= curReachStage then
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
      self.cacheLastReachStage[rechargeId] = curReachStage
    end
  end
end

local function PushNewRechargeHandle(self, message)
  self.rechargeStage[message.rechargeId] = {}
  self.rechargeStage[message.rechargeId].score = 0
  self.rechargeStage[message.rechargeId].endTime = message.endTime
  self.rechargeStage[message.rechargeId].rechargeId = message.rechargeId
  self.rechargeStage[message.rechargeId].startTime = message.startTime
  self.rechargeStage[message.rechargeId].stageInfo = {}
  self.rechargeStage[message.rechargeId].stageInfoExtend = {}
  self.rechargeStage[message.rechargeId].nextResetTime = message.nextResetTime or 0
  if self.rechargeStage[message.rechargeId].endTime and self.rechargeStage[message.rechargeId].nextResetTime ~= 0 and self.rechargeStage[message.rechargeId].endTime <= self.rechargeStage[message.rechargeId].nextResetTime then
    self.rechargeStage[message.rechargeId].nextResetTime = 0
  end
  SFSNetwork.SendMessage(MsgDefines.GetRechargeInfo, message.rechargeId)
end

local function SendReward(self, rechargeId, stageId)
  SFSNetwork.SendMessage(MsgDefines.ReceiveRechargeReward, tonumber(rechargeId), tonumber(stageId))
end

local function SendRewardHandle(self, message)
  local info = self.rechargeStage[message.rechargeId].stageInfo
  for i = 1, #info do
    if info[i].stageId == message.stageId then
      info[i]:UpdateState(1)
    end
  end
  local infoExtend = self.rechargeStage[message.rechargeId].stageInfoExtend
  if infoExtend then
    for i = 1, #infoExtend do
      if infoExtend[i].stageId == message.stageId then
        infoExtend[i]:UpdateState(1)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CumulativeReward, message.stageId)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
end

local function CheckIsShow(self)
  return DataCenter.ActivityListDataManager:CheckIsShowGiftPackPoint()
end

local function GetInfo(self)
  for i, v in pairs(self.rechargeStage) do
    if next(v) then
      return i, v
    end
  end
end

local function GetCurStage(self, rechargeId)
  local index = 0
  if self.rechargeStage[rechargeId] then
    local data = self.rechargeStage[rechargeId]
    local stageInfo = data.stageInfo
    for i = 1, #stageInfo do
      if data.score >= stageInfo[i].needScore then
        index = i
      end
    end
  end
  return index
end

local function GetRedNum(self)
  local count = 0
  for _, v in pairs(self.rechargeStage) do
    if next(v) then
      for i = 1, #v.stageInfo do
        if v.stageInfo[i].state == 0 and v.score >= v.stageInfo[i].needScore then
          count = count + 1
        end
      end
      if v.stageInfoExtend then
        for i = 1, #v.stageInfoExtend do
          if v.stageInfoExtend[i].state == 0 and v.score >= v.stageInfoExtend[i].needScore then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

local function GetActRedNum(self, id)
  local count = 0
  if self.rechargeStage[id] then
    local rechargeStage = self.rechargeStage[id]
    for i = 1, #rechargeStage.stageInfo do
      if rechargeStage.stageInfo[i].state == 0 and rechargeStage.score >= rechargeStage.stageInfo[i].needScore then
        count = count + 1
      end
    end
    if rechargeStage.stageInfoExtend then
      for i = 1, #rechargeStage.stageInfoExtend do
        if rechargeStage.stageInfoExtend[i].state == 0 and rechargeStage.score >= rechargeStage.stageInfoExtend[i].needScore then
          count = count + 1
        end
      end
    end
  end
  return count
end

local function GetRechargeStage(self, id)
  return self.rechargeStage[tonumber(id)]
end

local function CheckCanRecv(self)
  local id, data = self:GetInfo()
  for i = 1, #data.stageInfo do
    if data.stageInfo[i].state == 0 and data.score >= data.stageInfo[i].needScore then
      return i
    end
  end
  return 0
end

local function SetCurStage(self, Stage)
  self.tempStage = Stage
  self.isFirst = false
end

local function GetLastStage(self)
  return self.tempStage
end

local function GetStageIsFirst(self)
  return self.isFirst
end

local function CheckAddTimer(self)
  self:RemoveTimer()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if not table.IsNullOrEmpty(self.rechargeStage) then
    local minTime
    for i, v in pairs(self.rechargeStage) do
      if v.nextResetTime > 0 and curTime < v.nextResetTime then
        if not minTime then
          minTime = v.nextResetTime
        elseif minTime > v.nextResetTime then
          minTime = v.nextResetTime
        end
      end
    end
    if minTime then
      local function callback()
        self.refreshTimer = nil
        
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        for i, v in pairs(self.rechargeStage) do
          if v.nextResetTime > 0 and curTime > v.nextResetTime then
            v.nextResetTime = 0
            SFSNetwork.SendMessage(MsgDefines.GetRechargeInfo, v.rechargeId)
          end
        end
        self:CheckAddTimer()
      end
      
      self.refreshTimer = TimerManager:GetInstance():GetTimer(minTime - curTime, callback, nil, true)
      self.refreshTimer:Start()
    end
  end
end

local function RemoveTimer(self)
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
end

CumulativeRechargeManager.__init = __init
CumulativeRechargeManager.__delete = __delete
CumulativeRechargeManager.InitDat = InitDat
CumulativeRechargeManager.RequestDat = RequestDat
CumulativeRechargeManager.SendGetRechargeInfo = SendGetRechargeInfo
CumulativeRechargeManager.UpdateRechargeStageInfo = UpdateRechargeStageInfo
CumulativeRechargeManager.PushRechargeScoreHandle = PushRechargeScoreHandle
CumulativeRechargeManager.PushNewRechargeHandle = PushNewRechargeHandle
CumulativeRechargeManager.SendReward = SendReward
CumulativeRechargeManager.SendRewardHandle = SendRewardHandle
CumulativeRechargeManager.CheckIsShow = CheckIsShow
CumulativeRechargeManager.GetInfo = GetInfo
CumulativeRechargeManager.GetCurStage = GetCurStage
CumulativeRechargeManager.GetRedNum = GetRedNum
CumulativeRechargeManager.GetActRedNum = GetActRedNum
CumulativeRechargeManager.GetRechargeStage = GetRechargeStage
CumulativeRechargeManager.CheckCanRecv = CheckCanRecv
CumulativeRechargeManager.SetCurStage = SetCurStage
CumulativeRechargeManager.GetLastStage = GetLastStage
CumulativeRechargeManager.GetStageIsFirst = GetStageIsFirst
CumulativeRechargeManager.GetReachStage = GetReachStage
CumulativeRechargeManager.CheckAddTimer = CheckAddTimer
CumulativeRechargeManager.RemoveTimer = RemoveTimer
return CumulativeRechargeManager
