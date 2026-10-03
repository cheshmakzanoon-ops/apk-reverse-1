local UIQueenOfBloodRankListCtrl = BaseClass("UIQueenOfBloodRankListCtrl", UIBaseCtrl)

function UIQueenOfBloodRankListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueenOfBloodRankList)
end

function UIQueenOfBloodRankListCtrl:RefreshRankFullData(data)
  self.rankFullData = DataCenter.OffSeason1TaskDataManager:RefreshRankFullData(self.rankFullData, data)
end

function UIQueenOfBloodRankListCtrl:GetRankFullData()
  return self.rankFullData
end

function UIQueenOfBloodRankListCtrl:GetRankDataByQuality(quality)
  return DataCenter.OffSeason1TaskDataManager:GetRankDataByQuality(self.rankFullData, quality)
end

function UIQueenOfBloodRankListCtrl:ClearRankFullData()
  self.rankFullData = nil
end

return UIQueenOfBloodRankListCtrl
