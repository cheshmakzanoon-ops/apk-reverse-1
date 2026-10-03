local ServerBattleRewardDetailCtrl = BaseClass("ServerBattleRewardDetailCtrl", UIBaseCtrl)

function ServerBattleRewardDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleRewardDetail)
end

return ServerBattleRewardDetailCtrl
