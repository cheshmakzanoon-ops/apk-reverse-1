local DailyMustRewardMessage = BaseClass("DailyMustRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    if t.dailyMustList then
      DataCenter.DailyMustBuyManager:UpdateData(t)
    else
      DataCenter.DailyMustBuyManager:AddNewClaimedReward(t.index)
    end
  end
end

DailyMustRewardMessage.OnCreate = OnCreate
DailyMustRewardMessage.HandleMessage = HandleMessage
return DailyMustRewardMessage
