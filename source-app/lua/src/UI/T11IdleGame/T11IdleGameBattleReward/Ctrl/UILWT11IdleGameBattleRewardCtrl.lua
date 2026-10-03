local UILWT11IdleGameBattleRewardCtrl = BaseClass("UILWT11IdleGameBattleRewardCtrl", UIBaseCtrl)

function UILWT11IdleGameBattleRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameBattleReward)
end

return UILWT11IdleGameBattleRewardCtrl
