local LWActivityArenaRewardsCtrl = BaseClass("LWActivityArenaRewardsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRewards)
end

LWActivityArenaRewardsCtrl.CloseSelf = CloseSelf
return LWActivityArenaRewardsCtrl
