local UIKillZombieAlRewardCtrl = BaseClass("UIKillZombieAlRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIKillZombieAlReward)
end

UIKillZombieAlRewardCtrl.CloseSelf = CloseSelf
return UIKillZombieAlRewardCtrl
