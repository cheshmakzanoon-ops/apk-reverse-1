local LWReveiveTowerUpFirstRewardMessage = BaseClass("LWReveiveTowerUpFirstRewardMessage", SFSBaseMessage)
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
      local num = DataCenter.LWJeepAdventureManager:GetNowUnGetRewardNumByType(JeepAdventurePageType.TowerUp)
      DataCenter.LWTowerUpStageManager:UpdateFirstRewardedDict(t.firstRewardedArr)
      EventManager:GetInstance():Broadcast(EventId.ReveiveTowerUpFirstReward)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

LWReveiveTowerUpFirstRewardMessage.OnCreate = OnCreate
LWReveiveTowerUpFirstRewardMessage.HandleMessage = HandleMessage
return LWReveiveTowerUpFirstRewardMessage
