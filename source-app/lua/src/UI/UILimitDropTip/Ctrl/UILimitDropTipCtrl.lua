local UILimitDropTipCtrl = BaseClass("UILimitDropTipCtrl", UIBaseCtrl)

function UILimitDropTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILimitDropTipView)
end

return UILimitDropTipCtrl
