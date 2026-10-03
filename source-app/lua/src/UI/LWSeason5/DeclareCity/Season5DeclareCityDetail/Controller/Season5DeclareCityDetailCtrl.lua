local Season5DeclareCityDetailCtrl = BaseClass("Season5DeclareCityDetailCtrl", UIBaseCtrl)

function Season5DeclareCityDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.Season5DeclareCityDetail)
end

return Season5DeclareCityDetailCtrl
