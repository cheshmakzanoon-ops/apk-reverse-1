local ClientRewardToServerDataManager = BaseClass("ClientRewardToServerDataManager", CEventable)

function ClientRewardToServerDataManager:__init()
  self.rewards = {}
end

function ClientRewardToServerDataManager:__delete()
  self.rewards = nil
end

function ClientRewardToServerDataManager:GetRewardById(rewardId, identify)
  if rewardId == nil then
    return
  end
  self:GetRewardByIdList({rewardId}, identify)
end

function ClientRewardToServerDataManager:GetRewardByTwoId(rewardId1, rewardId2, identify)
  if rewardId1 == nil and rewardId2 == nil then
    return
  end
  if rewardId1 == rewardId2 then
    self:GetRewardByIdList({rewardId1}, identify)
  else
    self:GetRewardByIdList({rewardId1, rewardId2}, identify)
  end
end

function ClientRewardToServerDataManager:GetRewardByIdList(rewardIds, identify)
  if rewardIds == nil or #rewardIds == 0 then
    return
  end
  local needSendProto = false
  local eventData = {
    type = toInt(identify)
  }
  for _, rewardId in ipairs(rewardIds) do
    if self.rewards[rewardId] == nil then
      needSendProto = true
      break
    else
      eventData[rewardId] = self.rewards[rewardId]
    end
  end
  if not needSendProto then
    EventManager:GetInstance():Broadcast(EventId.CommonGetServerReward, eventData)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LWCommonGetReward, rewardIds, eventData.type)
end

function ClientRewardToServerDataManager:HandleServerData(t)
  if t == nil then
    return
  end
  for k, v in pairs(t) do
    if type(v) == "table" then
      self.rewards[k] = v
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CommonGetServerReward, t)
end

return ClientRewardToServerDataManager
