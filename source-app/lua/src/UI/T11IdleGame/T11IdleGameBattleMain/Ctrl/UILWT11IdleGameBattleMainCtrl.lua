local UILWT11IdleGameBattleMainCtrl = BaseClass("UILWT11IdleGameBattleMainCtrl", UIBaseCtrl)

function UILWT11IdleGameBattleMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameBattleMain)
end

return UILWT11IdleGameBattleMainCtrl
