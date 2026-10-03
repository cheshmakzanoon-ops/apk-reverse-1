local UILWSeasonCityOccupyDetailCtrl = BaseClass("UILWSeasonCityOccupyDetailCtrl", UIBaseCtrl)

function UILWSeasonCityOccupyDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyDetail)
end

return UILWSeasonCityOccupyDetailCtrl
