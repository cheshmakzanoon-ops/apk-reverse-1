local UIGhostreconRewardCtrl = BaseClass("UIGhostreconRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconReward)
end

UIGhostreconRewardCtrl.CloseSelf = CloseSelf
return UIGhostreconRewardCtrl
