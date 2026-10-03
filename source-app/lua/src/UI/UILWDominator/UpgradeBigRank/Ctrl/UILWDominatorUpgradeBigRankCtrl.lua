local UILWDominatorUpgradeBigRankCtrl = BaseClass("UILWDominatorUpgradeBigRankCtrl", UIBaseCtrl)

function UILWDominatorUpgradeBigRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorUpgradeBigRank)
end

return UILWDominatorUpgradeBigRankCtrl
