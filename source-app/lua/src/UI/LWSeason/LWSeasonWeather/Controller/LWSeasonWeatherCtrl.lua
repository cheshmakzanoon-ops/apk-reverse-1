local LWSeasonWeatherCtrl = BaseClass("LWSeasonWeatherCtrl", UIBaseCtrl)

function LWSeasonWeatherCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonWeather)
end

return LWSeasonWeatherCtrl
