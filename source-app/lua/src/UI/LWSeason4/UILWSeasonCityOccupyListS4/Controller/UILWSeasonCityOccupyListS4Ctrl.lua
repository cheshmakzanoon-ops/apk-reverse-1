local UILWSeasonCityOccupyListS4Ctrl = BaseClass("UILWSeasonCityOccupyListS4Ctrl", UIBaseCtrl)

function UILWSeasonCityOccupyListS4Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyListS4)
end

return UILWSeasonCityOccupyListS4Ctrl
