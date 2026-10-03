local UILWSeasonTradeShopCtrl = BaseClass("UILWSeasonTradeShopCtrl", UIBaseCtrl)

function UILWSeasonTradeShopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTradeShop)
end

return UILWSeasonTradeShopCtrl
