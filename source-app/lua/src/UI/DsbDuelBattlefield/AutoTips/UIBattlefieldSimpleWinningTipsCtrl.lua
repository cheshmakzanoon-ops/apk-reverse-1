local UIBattlefieldSimpleWinningTipsCtrl = BaseClass("UIBattlefieldSimpleWinningTipsCtrl", UIBaseCtrl)

function UIBattlefieldSimpleWinningTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattlefieldSimpleWinningTipsView)
end

return UIBattlefieldSimpleWinningTipsCtrl
