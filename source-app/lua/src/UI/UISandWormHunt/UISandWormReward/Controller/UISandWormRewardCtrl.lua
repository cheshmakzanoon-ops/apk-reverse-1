local UISandWormRewardCtrl = BaseClass("UISandWormRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormReward)
end

UISandWormRewardCtrl.CloseSelf = CloseSelf
return UISandWormRewardCtrl
