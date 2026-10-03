local UIBFDsbDuelBattleBuildDetailCtrl = BaseClass("UIBFDsbDuelBattleBuildDetailCtrl", UIBaseCtrl)

function UIBFDsbDuelBattleBuildDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelBattleBuildDetail)
end

return UIBFDsbDuelBattleBuildDetailCtrl
