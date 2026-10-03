local UIJeepAdventureFirstRewardsCtrl = BaseClass("UIJeepAdventureFirstRewardsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJeepAdventureFirstRewards)
end

local function SendGetFirstReward(self, pageType, id)
  if pageType == JeepAdventurePageType.Domintor then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveDominatorUpFirstReward, id)
  elseif pageType == JeepAdventurePageType.TowerUp then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveTowerUpFirstReward, id)
  end
end

UIJeepAdventureFirstRewardsCtrl.CloseSelf = CloseSelf
UIJeepAdventureFirstRewardsCtrl.SendGetFirstReward = SendGetFirstReward
return UIJeepAdventureFirstRewardsCtrl
