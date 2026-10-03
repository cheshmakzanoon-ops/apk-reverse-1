local UIActivityFrontBreakSundayRewardsCtrl = BaseClass("UIActivityFrontBreakSundayRewardsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityFrontBreakSundayRewards, {anim = false})
end

UIActivityFrontBreakSundayRewardsCtrl.CloseSelf = CloseSelf
return UIActivityFrontBreakSundayRewardsCtrl
