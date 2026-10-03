local LWReveiveDominatorUpFirstRewardMessage = BaseClass("LWReveiveDominatorUpFirstRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id or -1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      if t.reward then
        DataCenter.RewardManager:AddRewardsAndRes(t)
        DataCenter.RewardManager:ShowCommonReward(t)
      end
      local num = DataCenter.LWJeepAdventureManager:GetNowUnGetRewardNumByType(JeepAdventurePageType.Domintor)
      DataCenter.LWDominatorUpStageManager:UpdateFirstRewardedDict(t.firstRewardedArr)
      EventManager:GetInstance():Broadcast(EventId.ReveiveDominatorUpFirstReward)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

LWReveiveDominatorUpFirstRewardMessage.OnCreate = OnCreate
LWReveiveDominatorUpFirstRewardMessage.HandleMessage = HandleMessage
return LWReveiveDominatorUpFirstRewardMessage
