local Season5DeclareCityListCtrl = BaseClass("Season5DeclareCityListCtrl", UIBaseCtrl)

function Season5DeclareCityListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.Season5DeclareCityList)
end

return Season5DeclareCityListCtrl
