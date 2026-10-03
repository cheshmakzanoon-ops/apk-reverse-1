local LWUIZombieRushRewardCtrl = BaseClass("LWUIZombieRushRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIZombieRushRewardCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIZombieRushReward)
end

return LWUIZombieRushRewardCtrl
