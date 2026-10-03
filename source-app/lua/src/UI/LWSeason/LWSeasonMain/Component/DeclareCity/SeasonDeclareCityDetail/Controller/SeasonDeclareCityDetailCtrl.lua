local SeasonDeclareCityDetailCtrl = BaseClass("SeasonDeclareCityDetailCtrl", UIBaseCtrl)

function SeasonDeclareCityDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonDeclareCityDetail)
end

return SeasonDeclareCityDetailCtrl
