local UIHangUpRewardProbabilityCtrl = BaseClass("UIHangUpRewardProbabilityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHangUpRewardProbability)
end

UIHangUpRewardProbabilityCtrl.CloseSelf = CloseSelf
return UIHangUpRewardProbabilityCtrl
