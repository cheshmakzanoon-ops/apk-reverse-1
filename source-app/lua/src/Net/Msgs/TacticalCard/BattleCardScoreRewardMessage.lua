local BattleCardScoreRewardMessage = BaseClass("BattleCardScoreRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
end

BattleCardScoreRewardMessage.OnCreate = OnCreate
BattleCardScoreRewardMessage.HandleMessage = HandleMessage
return BattleCardScoreRewardMessage
