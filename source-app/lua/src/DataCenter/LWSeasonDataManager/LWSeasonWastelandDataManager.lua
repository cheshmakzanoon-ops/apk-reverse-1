local LWSeasonWastelandDataManager = BaseClass("LWSeasonWastelandDataManager")

function LWSeasonWastelandDataManager:__init()
  self.wastedlandBoxRewards = {}
  self.wastedlandData = {}
end

function LWSeasonWastelandDataManager:__delete()
  self.wastedlandBoxRewards = nil
  self.wastedlandData = nil
end

function LWSeasonWastelandDataManager:InitData(message)
  if message ~= nil then
    for k, v in pairs(message) do
      self.wastedlandData[tonumber(k)] = v
    end
  end
end

function LWSeasonWastelandDataManager:GetBoxRewardByActivityId(activityId)
  activityId = tonumber(activityId)
  local boxRewards = {}
  local actConfig = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actConfig == nil then
    return boxRewards
  end
  if not string.IsNullOrEmpty(actConfig.tableInfo) and actConfig.tableInfo == TableName.SEASON_CHEST then
    local group = tonumber(actConfig.subType or 0)
    if self.wastedlandBoxRewards ~= nil and self.wastedlandBoxRewards[activityId] ~= nil then
      boxRewards = self.wastedlandBoxRewards[activityId]
    else
      LocalController:instance():visitTable(TableName.SEASON_CHEST, function(id, lineData)
        local eachGroup = tonumber(lineData:getValue("group") or 0)
        if eachGroup == group then
          local showStr = string.split(lineData.show, ";")
          local tableData = {
            target = lineData.condition_score,
            reward = lineData.reward,
            notFinish = showStr[1],
            canReceive = showStr[2],
            received = showStr[3],
            isReward = 0,
            id = id
          }
          table.insert(boxRewards, tableData)
        end
      end)
      table.sort(boxRewards, function(a, b)
        local aScore = a.target or 0
        local bScore = b.target or 0
        return aScore < bScore
      end)
      self.wastedlandBoxRewards[activityId] = boxRewards
    end
  end
  local hasServerData = self.wastedlandData ~= nil and self.wastedlandData[activityId] ~= nil
  for index = 1, #boxRewards do
    local boxReward = boxRewards[index]
    if hasServerData then
      local activityWastelandData = self.wastedlandData[activityId]
      boxReward = boxRewards[index]
      boxReward.isReward = 0
      if activityWastelandData.scoreRewardChests ~= nil then
        for _, v in ipairs(activityWastelandData.scoreRewardChests) do
          if v == boxReward.id then
            boxReward.isReward = 1
            break
          end
        end
      end
    end
  end
  boxRewards.score = 0
  if hasServerData then
    local activityWastelandData = self.wastedlandData[activityId]
    boxRewards.score = activityWastelandData.score or 0
  end
  return boxRewards
end

function LWSeasonWastelandDataManager:WastelandBoxInfoMessage(t)
  local uuid = t.uuid
  if uuid then
    self.wastedlandData[uuid] = t
    EventManager:GetInstance():Broadcast(EventId.SeasonRefreshWastelandBoxInfo, uuid)
  end
end

function LWSeasonWastelandDataManager:ClaimWastelandBoxMessage(t)
  local uuid = t.uuid
  if uuid then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    if self.wastedlandData ~= nil and self.wastedlandData[uuid] ~= nil then
      local activityWastelandData = self.wastedlandData[uuid]
      if activityWastelandData and activityWastelandData.scoreRewardChests then
        table.insert(activityWastelandData.scoreRewardChests, t.chestId)
      end
    end
    DataCenter.RewardManager:ShowCommonReward({
      reward = t.reward
    })
    EventManager:GetInstance():Broadcast(EventId.SeasonRefreshWastelandBoxInfo, uuid)
  end
end

function LWSeasonWastelandDataManager:PushWastelandMessage(t)
  local uuid = t.uuid
  if uuid and self.wastedlandData ~= nil then
    self.wastedlandData[uuid] = t
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonRefreshWastelandDataChange, uuid)
end

function LWSeasonWastelandDataManager:GetRedCount(activityId)
  activityId = tonumber(activityId)
  local hasServerData = self.wastedlandData ~= nil and self.wastedlandData[activityId] ~= nil
  if not hasServerData then
    return 0
  end
  local boxRewards = self:GetBoxRewardByActivityId(activityId)
  if boxRewards == nil then
    return 0
  end
  local count = 0
  for index = 1, #boxRewards do
    local boxReward = boxRewards[index]
    if boxReward.isReward == 0 and boxReward.target <= boxRewards.score then
      count = count + 1
    end
  end
  return count
end

return LWSeasonWastelandDataManager
