local GoldTreeRewardCtrl = BaseClass("GoldTreeRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldTreeReward)
end

GoldTreeRewardCtrl.CloseSelf = CloseSelf
return GoldTreeRewardCtrl
