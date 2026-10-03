local UIActivityKillZombieActionRewardCtrl = BaseClass("UIActivityKillZombieActionRewardCtrl", UIBaseCtrl)

function UIActivityKillZombieActionRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityKillZombieActionReward)
end

return UIActivityKillZombieActionRewardCtrl
