local UIBFDsbDuelBattleBuildStateCtrl = BaseClass("UIBFDsbDuelBattleBuildStateCtrl", UIBaseCtrl)

function UIBFDsbDuelBattleBuildStateCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelBattleBuildState)
end

return UIBFDsbDuelBattleBuildStateCtrl
