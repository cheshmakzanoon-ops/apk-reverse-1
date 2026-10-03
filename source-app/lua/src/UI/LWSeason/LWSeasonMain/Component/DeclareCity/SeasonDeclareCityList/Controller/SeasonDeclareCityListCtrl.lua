local SeasonDeclareCityListCtrl = BaseClass("SeasonDeclareCityListCtrl", UIBaseCtrl)

function SeasonDeclareCityListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonDeclareCityList)
end

return SeasonDeclareCityListCtrl
