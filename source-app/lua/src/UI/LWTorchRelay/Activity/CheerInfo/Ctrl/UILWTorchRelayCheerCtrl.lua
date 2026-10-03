local UILWTorchRelayCheerCtrl = BaseClass("UILWTorchRelayCheerCtrl", UIBaseCtrl)

function UILWTorchRelayCheerCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TorchRelayCheerInfo)
end

return UILWTorchRelayCheerCtrl
