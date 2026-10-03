local UILWSeasonTradeShopRefreshCtrl = BaseClass("UILWSeasonTradeShopRefreshCtrl", UIBaseCtrl)

function UILWSeasonTradeShopRefreshCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTradeShopRefresh)
end

return UILWSeasonTradeShopRefreshCtrl
