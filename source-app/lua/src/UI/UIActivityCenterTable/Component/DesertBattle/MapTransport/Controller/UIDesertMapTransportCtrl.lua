local UIDesertMapTransportCtrl = BaseClass("UIDesertMapTransportCtrl", UIBaseCtrl)

function UIDesertMapTransportCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertMapTransport)
end

return UIDesertMapTransportCtrl
