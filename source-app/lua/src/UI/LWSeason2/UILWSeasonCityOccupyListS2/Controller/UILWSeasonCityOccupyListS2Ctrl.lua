local UILWSeasonCityOccupyListS2Ctrl = BaseClass("UILWSeasonCityOccupyListS2Ctrl", UIBaseCtrl)

function UILWSeasonCityOccupyListS2Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyListS2)
end

return UILWSeasonCityOccupyListS2Ctrl
