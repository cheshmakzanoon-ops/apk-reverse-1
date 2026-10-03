local UILWSeasonCityOccupyListCtrl = BaseClass("UILWSeasonCityOccupyListCtrl", UIBaseCtrl)

function UILWSeasonCityOccupyListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyList)
end

return UILWSeasonCityOccupyListCtrl
