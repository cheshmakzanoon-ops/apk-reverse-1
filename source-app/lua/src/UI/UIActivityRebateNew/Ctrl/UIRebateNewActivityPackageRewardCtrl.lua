local UIRebateNewActivityPackageRewardCtrl = BaseClass("UIRebateNewActivityPackageRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityRebateNewPackageReward)
end

UIRebateNewActivityPackageRewardCtrl.CloseSelf = CloseSelf
return UIRebateNewActivityPackageRewardCtrl
