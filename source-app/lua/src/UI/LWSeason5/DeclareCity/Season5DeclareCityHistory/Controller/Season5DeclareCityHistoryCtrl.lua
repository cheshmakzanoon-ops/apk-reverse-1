local Season5DeclareCityHistoryCtrl = BaseClass("Season5DeclareCityHistoryCtrl", UIBaseCtrl)

function Season5DeclareCityHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.Season5DeclareCityHistory)
end

return Season5DeclareCityHistoryCtrl
