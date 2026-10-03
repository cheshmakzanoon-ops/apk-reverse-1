local DigTreasureBoxRewardManager = BaseClass("DigTreasureBoxRewardManager", CEventable)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

function DigTreasureBoxRewardManager:__init()
  self.rewardList = nil
  self.activityId = nil
  self.scoreItemId = nil
  self.openTips = nil
end

function DigTreasureBoxRewardManager:__delete()
  self.rewardList = nil
  self.activityId = nil
  self.scoreItemId = nil
  self.openTips = nil
end

function DigTreasureBoxRewardManager:SendMainBoxRewardUIMessage()
  SFSNetwork.SendMessage(MsgDefines.HeroDispatchTreasureV2GetInfo)
end

function DigTreasureBoxRewardManager:SendGetBoxRewardMessage()
  SFSNetwork.SendMessage(MsgDefines.HeroDispatchTreasureV2Reward)
end

function DigTreasureBoxRewardManager:OnTreasureBoxRewardData(message)
  if message.rewardList then
    self.rewardList = message.rewardList
  end
  if message.reward then
    local rewards = message.reward
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  EventManager:GetInstance():Broadcast(EventId.TreasureBoxReward)
end

function DigTreasureBoxRewardManager:SetActId(actId)
  self.activityId = actId
end

function DigTreasureBoxRewardManager:GetActId()
  if self.activityId == nil then
    local data = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.OFF_SEASON_Treasure_V2.Type)
    if data then
      self.activityId = data.activityId
    end
  end
  return self.activityId
end

function DigTreasureBoxRewardManager:GetBoxRewardItemCount()
  if self.scoreItemId == nil then
    local actId = self:GetActId()
    if actId then
      local lineData = LocalController:instance():getLine(TableName.Activity, actId)
      self.scoreItemId = lineData.para_3
    else
      return 0
    end
  end
  local itemData = DataCenter.ItemData:GetItemById(self.scoreItemId)
  local count = 0
  if itemData then
    count = itemData.count or 0
  end
  return count
end

function DigTreasureBoxRewardManager:GetTreasureBoxRewardList()
  return self.rewardList
end

function DigTreasureBoxRewardManager:GetMaxNum()
  local maxTarget
  if self.rewardList then
    for _, item in ipairs(self.rewardList) do
      if item.target ~= nil and (maxTarget == nil or maxTarget < item.target) then
        maxTarget = item.target
      end
    end
  end
  return maxTarget
end

function DigTreasureBoxRewardManager:GetOpenState()
  return self.openTips
end

function DigTreasureBoxRewardManager:SetOpenState()
  self.openTips = true
end

return DigTreasureBoxRewardManager
