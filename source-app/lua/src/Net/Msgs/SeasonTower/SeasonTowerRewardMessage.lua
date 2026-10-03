local SeasonTowerRewardMessage = BaseClass("SeasonTowerRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonTowerRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", param.stageId)
end

function SeasonTowerRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonTowerManager:UpdateServerRewardList(t.stageId, t.rewardList)
    local rewards = t.rewards or {}
    if not table.IsNullOrEmpty(rewards) then
      DataCenter.RewardManager:AddRewards(rewards)
      DataCenter.RewardManager:ShowCommonReward({reward = rewards})
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonTower_RefreshBubble)
end

return SeasonTowerRewardMessage
