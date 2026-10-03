local UIBattlefieldDsbDuelBattleRankCtrl = BaseClass("UIBattlefieldDsbDuelBattleRankCtrl", UIBaseCtrl)

function UIBattlefieldDsbDuelBattleRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattlefieldDsbDuelBattleRankView)
end

return UIBattlefieldDsbDuelBattleRankCtrl
