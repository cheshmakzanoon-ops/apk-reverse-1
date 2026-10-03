local UIWinterStormAchievementListCtrl = BaseClass("UIWinterStormAchievementListCtrl", UIBaseCtrl)

function UIWinterStormAchievementListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormAchievementList)
end

return UIWinterStormAchievementListCtrl
