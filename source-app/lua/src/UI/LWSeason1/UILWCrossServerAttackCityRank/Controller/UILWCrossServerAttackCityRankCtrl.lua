local UILWCrossServerAttackCityRankCtrl = BaseClass("UILWCrossServerAttackCityRankCtrl", UIBaseCtrl)

function UILWCrossServerAttackCityRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCrossServerAttackCityRank)
end

return UILWCrossServerAttackCityRankCtrl
