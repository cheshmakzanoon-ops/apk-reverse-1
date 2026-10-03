local UICityEventZombieSeaRewardsCtrl = BaseClass("UICityEventZombieSeaRewardsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityEventZombieSeaReward)
end

UICityEventZombieSeaRewardsCtrl.CloseSelf = CloseSelf
return UICityEventZombieSeaRewardsCtrl
