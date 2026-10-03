local KillZombieAlChallengeRankCtrl = BaseClass("KillZombieAlChallengeRankCtrl", UIBaseCtrl)

function KillZombieAlChallengeRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.KillZombieAlChallengeRank)
end

function KillZombieAlChallengeRankCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return KillZombieAlChallengeRankCtrl
