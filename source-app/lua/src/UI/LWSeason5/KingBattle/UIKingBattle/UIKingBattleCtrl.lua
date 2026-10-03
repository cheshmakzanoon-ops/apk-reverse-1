local UIKingBattleCtrl = BaseClass("UIKingBattleCtrl", UIBaseCtrl)

function UIKingBattleCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIKingBattle)
end

return UIKingBattleCtrl
