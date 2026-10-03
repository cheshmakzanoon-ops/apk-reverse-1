local ServerBattleScoreDetailCtrl = BaseClass("ServerBattleScoreDetailCtrl", UIBaseCtrl)

function ServerBattleScoreDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleScoreDetail)
end

return ServerBattleScoreDetailCtrl
