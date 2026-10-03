local UILWSeasonFactionWarScoreRankListCtrl = BaseClass("UILWSeasonFactionWarScoreRankListCtrl", UIBaseCtrl)

function UILWSeasonFactionWarScoreRankListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarScoreRankList)
end

return UILWSeasonFactionWarScoreRankListCtrl
