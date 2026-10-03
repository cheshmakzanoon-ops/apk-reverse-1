local UISeasonSynthesisRateTipCtrl = BaseClass("UISeasonSynthesisRateTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonSynthesisRateTip)
end

UISeasonSynthesisRateTipCtrl.CloseSelf = CloseSelf
return UISeasonSynthesisRateTipCtrl
