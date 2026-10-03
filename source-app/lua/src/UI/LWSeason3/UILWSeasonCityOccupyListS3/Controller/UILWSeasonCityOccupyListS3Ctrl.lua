local UILWSeasonCityOccupyListS3Ctrl = BaseClass("UILWSeasonCityOccupyListS3Ctrl", UIBaseCtrl)

function UILWSeasonCityOccupyListS3Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCityOccupyListS3)
end

return UILWSeasonCityOccupyListS3Ctrl
