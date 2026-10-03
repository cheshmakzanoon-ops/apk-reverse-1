local UIActivityKillZombieHelpRewardCtrl = BaseClass("UIActivityKillZombieHelpRewardCtrl", UIBaseCtrl)

function UIActivityKillZombieHelpRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityKillZombieHelpReward)
end

return UIActivityKillZombieHelpRewardCtrl
