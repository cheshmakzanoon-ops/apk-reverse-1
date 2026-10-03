local SeasonWeatherDetailCtrl = BaseClass("SeasonWeatherDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonWeatherDetail)
end

SeasonWeatherDetailCtrl.CloseSelf = CloseSelf
return SeasonWeatherDetailCtrl
