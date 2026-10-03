local UIAllianceKirovPlanTimeCtrl = BaseClass("UIAllianceKirovPlanTimeCtrl", UIBaseCtrl)

function UIAllianceKirovPlanTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceKirovPlanTime)
end

return UIAllianceKirovPlanTimeCtrl
