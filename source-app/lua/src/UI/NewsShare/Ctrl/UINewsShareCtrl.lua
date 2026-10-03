local UINewsShareCtrl = BaseClass("UINewsShareCtrl", UIBaseCtrl)

function UINewsShareCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINewsShareView)
end

return UINewsShareCtrl
