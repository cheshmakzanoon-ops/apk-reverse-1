local MultipleParkourActivityManager = BaseClass("MultipleParkourActivityManager")

function MultipleParkourActivityManager:OnGetActivityInfo(info)
  self.info = info
  self.info.rewardCount = 0
  local taskArr = self.info.taskArr
  if taskArr then
    for _, v in ipairs(taskArr) do
      if v.state == 1 then
        self.info.rewardCount = self.info.rewardCount + 1
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourActivityInfoChanged, self.info.id)
end

function MultipleParkourActivityManager:GetRedDotCount()
  if not self.info then
    return 0
  end
  local rewardCount = self.info.rewardCount or 0
  local day = self.info.dayTimes == 0 and 1 or 0
  return rewardCount + day, rewardCount, day
end

function MultipleParkourActivityManager:HandleTaskRewardMessage(message)
  local t = message.reward
  if t then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  if not self.info then
    return
  end
  if tonumber(self.info.activityId) ~= tonumber(message.activityId) then
    return
  end
  local taskArray = message.taskArray
  if taskArray and #taskArray == 1 then
    local taskData = taskArray[1]
    local taskId = taskData.taskId
    for _, v in ipairs(self.info.taskArray) do
      if v.taskId == taskId then
        v.state = taskData.state
        if v.state == 1 then
          self.info.rewardCount = math.max(0, self.info.rewardCount - 1)
        end
        break
      end
    end
    EventManager:GetInstance():Broadcast(EventId.MultipleParkourTaskRewardChanged, self.info.id)
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.info.activityId))
  end
end

return MultipleParkourActivityManager
