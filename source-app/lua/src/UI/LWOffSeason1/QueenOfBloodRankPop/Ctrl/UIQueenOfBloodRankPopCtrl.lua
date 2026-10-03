local UIQueenOfBloodRankPopCtrl = BaseClass("UIQueenOfBloodRankPopCtrl", UIBaseCtrl)

function UIQueenOfBloodRankPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIQueenOfBloodRankPop)
end

function UIQueenOfBloodRankPopCtrl:RefreshRankFullData(data)
  self.rankFullData = DataCenter.OffSeason1TaskDataManager:RefreshRankFullData(self.rankFullData, data)
end

function UIQueenOfBloodRankPopCtrl:GetRankDataByQuality(quality)
  return DataCenter.OffSeason1TaskDataManager:GetRankDataByQuality(self.rankFullData, quality)
end

function UIQueenOfBloodRankPopCtrl:GetRankFullData()
  return self.rankFullData
end

function UIQueenOfBloodRankPopCtrl:ClearRankFullData()
  self.rankFullData = nil
end

return UIQueenOfBloodRankPopCtrl
