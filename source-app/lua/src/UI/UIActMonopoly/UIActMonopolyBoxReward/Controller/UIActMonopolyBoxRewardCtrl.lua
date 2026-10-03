local UIActMonopolyBoxRewardCtrl = BaseClass("UIActMonopolyBoxRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActMonopolyBoxReward)
end

UIActMonopolyBoxRewardCtrl.CloseSelf = CloseSelf
return UIActMonopolyBoxRewardCtrl
