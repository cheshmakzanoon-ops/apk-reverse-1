local UITrainPrepareThanksPopupCtrl = BaseClass("UITrainPrepareThanksPopupCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepareThanksPopup)
end

UITrainPrepareThanksPopupCtrl.CloseSelf = CloseSelf
return UITrainPrepareThanksPopupCtrl
