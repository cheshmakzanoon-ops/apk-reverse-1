local UIDesertMapUICtrl = BaseClass("UIDesertMapUICtrl", UIBaseCtrl)

function UIDesertMapUICtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertMapUI)
end

return UIDesertMapUICtrl
