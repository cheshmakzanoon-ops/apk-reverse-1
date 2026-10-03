local UIKingBattleRankCtrl = BaseClass("UIKingBattleRankCtrl", UIBaseCtrl)

function UIKingBattleRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIKingBattleRank)
end

return UIKingBattleRankCtrl
