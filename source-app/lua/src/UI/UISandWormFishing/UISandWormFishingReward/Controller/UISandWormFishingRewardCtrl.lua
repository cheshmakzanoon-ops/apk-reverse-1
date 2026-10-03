local UISandWormFishingRewardCtrl = BaseClass("UISandWormFishingRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormFishingReward)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISandWormFishingRewardCtrl.CloseSelf = CloseSelf
UISandWormFishingRewardCtrl.Close = Close
return UISandWormFishingRewardCtrl
