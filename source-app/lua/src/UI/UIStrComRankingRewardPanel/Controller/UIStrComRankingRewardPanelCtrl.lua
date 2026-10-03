local UIStrComRankingRewardPanel = BaseClass("UIStrComRankingRewardPanel", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStrComRankingRewardPanel, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

UIStrComRankingRewardPanel.CloseSelf = CloseSelf
return UIStrComRankingRewardPanel
