local ServerBattleRankCtrl = BaseClass("ServerBattleRankCtrl", UIBaseCtrl)

function ServerBattleRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentServerBattleRank)
end

return ServerBattleRankCtrl
