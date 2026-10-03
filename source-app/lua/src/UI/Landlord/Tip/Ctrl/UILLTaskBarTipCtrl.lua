local UILLTaskBarTipCtrl = BaseClass("UILLTaskBarTipCtrl", UIBaseCtrl)

function UILLTaskBarTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLTaskBarTip)
end

return UILLTaskBarTipCtrl
