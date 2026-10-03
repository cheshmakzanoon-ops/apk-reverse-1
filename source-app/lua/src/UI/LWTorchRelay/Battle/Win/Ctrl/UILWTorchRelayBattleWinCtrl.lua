local UILWTorchRelayBattleWinCtrl = BaseClass("UILWTorchRelayBattleWinCtrl", UIBaseCtrl)

function UILWTorchRelayBattleWinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TorchRelayBattleWin)
end

return UILWTorchRelayBattleWinCtrl
