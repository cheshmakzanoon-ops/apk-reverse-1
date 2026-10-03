local UILWSeasonScoreDetailCtrl = BaseClass("UILWSeasonScoreDetailCtrl", UIBaseCtrl)

function UILWSeasonScoreDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonScoreDetail)
end

return UILWSeasonScoreDetailCtrl
