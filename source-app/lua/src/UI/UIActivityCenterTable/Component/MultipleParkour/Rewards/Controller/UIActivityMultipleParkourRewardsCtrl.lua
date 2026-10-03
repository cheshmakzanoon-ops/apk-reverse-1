local UIActivityMultipleParkourRewardsCtrl = BaseClass("UIActivityMultipleParkourRewards", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityMultipleParkourRewards, {anim = false})
end

UIActivityMultipleParkourRewardsCtrl.CloseSelf = CloseSelf
return UIActivityMultipleParkourRewardsCtrl
