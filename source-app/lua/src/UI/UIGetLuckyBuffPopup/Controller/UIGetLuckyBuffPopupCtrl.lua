local UIGetLuckyBuffPopupCtrl = BaseClass("UIGetLuckyBuffPopupCtrl", UIBaseCtrl)

function UIGetLuckyBuffPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGetLuckyBuffPopup)
end

return UIGetLuckyBuffPopupCtrl
