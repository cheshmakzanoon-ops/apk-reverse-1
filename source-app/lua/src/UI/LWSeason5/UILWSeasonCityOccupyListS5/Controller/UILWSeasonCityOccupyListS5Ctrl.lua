local UILWSeasonCityOccupyListS5Ctrl = BaseClass("UILWSeasonCityOccupyListS5Ctrl", UIBaseCtrl)

function UILWSeasonCityOccupyListS5Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyListS5)
end

return UILWSeasonCityOccupyListS5Ctrl
