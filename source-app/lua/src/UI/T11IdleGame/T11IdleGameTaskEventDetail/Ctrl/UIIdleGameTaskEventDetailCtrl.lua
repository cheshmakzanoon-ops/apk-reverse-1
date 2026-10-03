local UIIdleGameTaskEventDetailCtrl = BaseClass("UIIdleGameTaskEventDetailCtrl", UIBaseCtrl)

function UIIdleGameTaskEventDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventDetail)
end

return UIIdleGameTaskEventDetailCtrl
