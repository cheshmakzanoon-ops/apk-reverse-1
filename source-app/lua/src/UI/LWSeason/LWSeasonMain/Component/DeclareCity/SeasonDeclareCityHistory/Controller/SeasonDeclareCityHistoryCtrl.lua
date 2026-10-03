local SeasonDeclareCityHistoryCtrl = BaseClass("SeasonDeclareCityHistoryCtrl", UIBaseCtrl)

function SeasonDeclareCityHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonDeclareCityHistory)
end

return SeasonDeclareCityHistoryCtrl
