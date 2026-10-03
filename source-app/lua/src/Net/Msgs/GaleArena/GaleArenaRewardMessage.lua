local GaleArenaRewardMessage = BaseClass("GaleArenaRewardMessage", SFSBaseMessage)
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
      DataCenter.NewGaleArenaManager:NewArenaRewardHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaRewardMessage.OnCreate = OnCreate
GaleArenaRewardMessage.HandleMessage = HandleMessage
return GaleArenaRewardMessage
