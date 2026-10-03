local UIIOSVersionUpdateTipCtrl = BaseClass("UIIOSVersionUpdateTipCtrl", UIBaseCtrl)

function UIIOSVersionUpdateTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIIOSVersionUpdateTip)
end

return UIIOSVersionUpdateTipCtrl
