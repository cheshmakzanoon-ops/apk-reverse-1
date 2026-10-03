local SandWormTaskClaimRewardMessage = BaseClass("SandWormTaskClaimRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, taskId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    if t.reward then
      local fakeMsg = {
        reward = t.reward
      }
      DataCenter.RewardManager:AddRewardsAndRes(fakeMsg)
      DataCenter.RewardManager:ShowCommonReward(fakeMsg)
    end
    DataCenter.SandWormHuntDataManager:HandleSandWormTaskClaimReward(t)
  end
end

SandWormTaskClaimRewardMessage.OnCreate = OnCreate
SandWormTaskClaimRewardMessage.HandleMessage = HandleMessage
return SandWormTaskClaimRewardMessage
