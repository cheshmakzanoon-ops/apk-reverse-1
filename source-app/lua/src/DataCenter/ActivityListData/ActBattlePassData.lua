local ActBattlePassData = BaseClass("ActBattlePassData")
local Localization = CS.GameEntry.Localization
local ActBattlePassInfo = require("DataCenter.ActivityListData.ActBattlePassInfo")

local function __init(self)
  self.list = {}
end

local function __delete(self)
  self.list = nil
end

local function SetActivityId(self, id)
  self.list[tonumber(id)] = {}
end

local function ParseEventData(self, message)
  if message == nil then
    return
  end
  if self.list[message.activityId] then
    local info = ActBattlePassInfo.New()
    info:ParseOther(message)
    if message.battlePass then
      local battlePass = message.battlePass
      info:ParseBattlePass(battlePass, message.activityType)
    end
    if message.stateInfo then
      local stateInfo = message.stateInfo
      info:ParseStateInfo(stateInfo, message.activityType)
    end
    if message.taskArr then
      local taskArr = message.taskArr
      info:ParseTaskArr(taskArr, message.activityType)
    end
    self.list[message.activityId] = info
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePass)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function GetInfoByActId(self, activityId)
  if self.list[activityId] then
    return self.list[activityId]
  end
  return nil
end

local function GetTaskRewardHandle(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseBattlePass(message.battlePass)
    data:RefreshTaskState(message, message.type)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassTask)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function GetStageRewardHandle(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:RefreshStageState(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassStage)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function ReceiveBattlePassExtraRewardHandle(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseBattlePass(message.battlePass)
    data:ParseOther(message)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRefresh, message.activityId)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function ReceiveBattlePassAllRewardHandle(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  local rewardShowData = {}
  local addScore = 0
  if message.addScore then
    addScore = message.addScore
  end
  if 0 < addScore then
    table.insert(rewardShowData, {
      type = RewardType.BATTLE_PASS,
      value = addScore
    })
  end
  if message.reward and 0 < #message.reward then
    for i, v in ipairs(message.reward) do
      table.insert(rewardShowData, v)
    end
  end
  DataCenter.RewardManager:ShowCommonReward({reward = rewardShowData})
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseBattlePass(message.battlePass)
    data:ParseStateInfo(message.stateInfo)
    data:ParseOther(message)
    local taskArr = message.taskArr
    if taskArr then
      data:RefreshTaskState(nil, taskArr, message.type)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassTask)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRefresh, message.activityId)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function BuyBattlePassLevelHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseBattlePass(message.battlePass)
    UIUtil.ShowTips(Localization:GetString("320449", data.battlePass.level))
  end
  if message.gold ~= nil then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRefresh, message.activityId)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function PushBattlePassUpdateHandle(self, message, type)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseBattlePass(message.battlePass)
    for i = 1, 2 do
      data:TaskSortHandle(i, type)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRefresh, message.activityId)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function PushBattlePassTaskUpdateHandle(self, message, id, a_task)
  local actId = id or message.activityId
  local taskArr = a_task or message.taskArr
  if not actId or not taskArr then
    return
  end
  local data = self:GetInfoByActId(actId)
  if data and next(data) then
    data:RefreshTaskState(nil, taskArr, message.type)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassTask)
  EventManager:GetInstance():Broadcast(EventId.ActBattlePassRed)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
end

local function PushAllBattlePassTaskHandle(self, message)
  local data = self:GetInfoByActId(message.activityId)
  if data and next(data) then
    data:ParseTaskArr(message.taskArr)
    data:ParseOther(message)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonBattlePassTabRedPoint, message.activityId)
  end
end

local function GetActRed(self, actId)
  local data = self:GetInfoByActId(actId)
  if data and next(data) then
    return data:GetRedNum()
  end
  return 0
end

local function CheckCurGetReward(self, actId)
  local data = self:GetInfoByActId(actId)
  if data and next(data) then
    return data:CheckCurGetReward()
  end
end

ActBattlePassData.__init = __init
ActBattlePassData.__delete = __delete
ActBattlePassData.SetActivityId = SetActivityId
ActBattlePassData.ParseEventData = ParseEventData
ActBattlePassData.GetInfoByActId = GetInfoByActId
ActBattlePassData.GetTaskRewardHandle = GetTaskRewardHandle
ActBattlePassData.GetStageRewardHandle = GetStageRewardHandle
ActBattlePassData.ReceiveBattlePassExtraRewardHandle = ReceiveBattlePassExtraRewardHandle
ActBattlePassData.ReceiveBattlePassAllRewardHandle = ReceiveBattlePassAllRewardHandle
ActBattlePassData.BuyBattlePassLevelHandle = BuyBattlePassLevelHandle
ActBattlePassData.PushBattlePassUpdateHandle = PushBattlePassUpdateHandle
ActBattlePassData.PushBattlePassTaskUpdateHandle = PushBattlePassTaskUpdateHandle
ActBattlePassData.PushAllBattlePassTaskHandle = PushAllBattlePassTaskHandle
ActBattlePassData.GetActRed = GetActRed
ActBattlePassData.CheckCurGetReward = CheckCurGetReward
return ActBattlePassData
