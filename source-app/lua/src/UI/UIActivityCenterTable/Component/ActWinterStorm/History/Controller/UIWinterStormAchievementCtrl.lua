local UIWinterStormAchievementCtrl = BaseClass("UIWinterStormAchievementCtrl", UIBaseCtrl)

function UIWinterStormAchievementCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormAchievement)
end

return UIWinterStormAchievementCtrl
