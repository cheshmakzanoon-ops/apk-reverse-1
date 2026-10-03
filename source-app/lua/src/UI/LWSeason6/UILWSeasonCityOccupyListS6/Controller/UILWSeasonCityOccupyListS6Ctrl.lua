local UILWSeasonCityOccupyListS6Ctrl = BaseClass("UILWSeasonCityOccupyListS6Ctrl", UIBaseCtrl)

function UILWSeasonCityOccupyListS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyListS6)
end

return UILWSeasonCityOccupyListS6Ctrl
