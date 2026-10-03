local UILWTorchRelayBattleMainCtrl = BaseClass("UILWTorchRelayBattleMainCtrl", UIBaseCtrl)

function UILWTorchRelayBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TorchRelayBattleMain)
end

return UILWTorchRelayBattleMainCtrl
