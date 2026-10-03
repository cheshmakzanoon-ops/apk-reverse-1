local UIIdleGameTaskEventNewTipsCtrl = BaseClass("UIIdleGameTaskEventNewTipsCtrl", UIBaseCtrl)

function UIIdleGameTaskEventNewTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIdleGameTaskEventNewTips)
end

return UIIdleGameTaskEventNewTipsCtrl
