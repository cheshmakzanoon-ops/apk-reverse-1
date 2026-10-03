local FetchOutpostBattleRewardMessage = BaseClass("FetchOutpostBattleRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostBattleRewardMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function FetchOutpostBattleRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleInfo)
end

return FetchOutpostBattleRewardMessage
