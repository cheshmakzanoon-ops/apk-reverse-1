local SeasonPreviewRankPanelCtrl = BaseClass("SeasonPreviewRankPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUISeasonPreviewRank)
end

SeasonPreviewRankPanelCtrl.CloseSelf = CloseSelf
return SeasonPreviewRankPanelCtrl
