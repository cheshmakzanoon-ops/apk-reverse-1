local UIShareLuckyBuffPopupCtrl = BaseClass("UIShareLuckyBuffPopupCtrl", UIBaseCtrl)

function UIShareLuckyBuffPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShareLuckyBuffPopup)
end

return UIShareLuckyBuffPopupCtrl
