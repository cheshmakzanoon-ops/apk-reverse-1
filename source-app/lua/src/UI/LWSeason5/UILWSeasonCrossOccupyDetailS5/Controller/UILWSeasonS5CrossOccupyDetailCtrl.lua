local UILWSeasonS5CrossOccupyDetailCtrl = BaseClass("UILWSeasonS5CrossOccupyDetailCtrl", UIBaseCtrl)

function UILWSeasonS5CrossOccupyDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonS5CrossOccupyDetail)
end

return UILWSeasonS5CrossOccupyDetailCtrl
