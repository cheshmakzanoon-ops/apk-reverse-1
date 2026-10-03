local KillZombieGetTaskRewardMessage = BaseClass("KillZombieGetTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieGetTaskRewardMessage:OnCreate(count)
  base.OnCreate(self)
  self.sfsObj:PutInt("count", count)
end

function KillZombieGetTaskRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    EventManager:GetInstance():Broadcast(EventId.MonsterChallengedTaskReward, t.rewardInfos)
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
  SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
end

return KillZombieGetTaskRewardMessage
