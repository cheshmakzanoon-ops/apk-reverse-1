local ActChampionBattleRewardMessage = BaseClass("ActChampionBattleRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, boxIndex)
  base.OnCreate(self)
  self.sfsObj:PutLong("boxIndex", boxIndex)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  local rewardInfo = message.reward
  if rewardInfo ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.ActChampionBattleManager:RefreshChampionBattleInfo(message)
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleReceiveBoxBack)
  end
end

ActChampionBattleRewardMessage.OnCreate = OnCreate
ActChampionBattleRewardMessage.HandleMessage = HandleMessage
return ActChampionBattleRewardMessage
