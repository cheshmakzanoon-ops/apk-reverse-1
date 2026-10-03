local UICounterAttackRewardCtrl = BaseClass("UICounterAttackRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICounterAttackReward)
end

UICounterAttackRewardCtrl.CloseSelf = CloseSelf
return UICounterAttackRewardCtrl
