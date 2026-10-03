local NewArenaRewardMessage = BaseClass("NewArenaRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, target)
  base.OnCreate(self)
  self.sfsObj:PutInt("target", target)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.NewPeakArenaManager:NewArenaRewardHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

NewArenaRewardMessage.OnCreate = OnCreate
NewArenaRewardMessage.HandleMessage = HandleMessage
return NewArenaRewardMessage
