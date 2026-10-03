local LWUISeasonTowerRankCtrl = BaseClass("LWUISeasonTowerRankCtrl", UIBaseCtrl)

function LWUISeasonTowerRankCtrl:GetRankData(stageId)
  return DataCenter.LWSeasonTowerManager:GetRankData(stageId)
end

function LWUISeasonTowerRankCtrl:GetRankRewardShowList()
  return DataCenter.LWSeasonTowerManager:GetRankRewardShowList()
end

function LWUISeasonTowerRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISeasonTowerRank)
end

return LWUISeasonTowerRankCtrl
