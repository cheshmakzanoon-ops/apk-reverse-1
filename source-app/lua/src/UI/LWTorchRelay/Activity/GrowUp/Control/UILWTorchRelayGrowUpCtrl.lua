local UILWTorchRelayGrowUpCtrl = BaseClass("UILWTorchRelayGrowUpCtrl", UIBaseCtrl)

function UILWTorchRelayGrowUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TorchRelayGrowUp)
end

return UILWTorchRelayGrowUpCtrl
