local UILWAllianceShopCtrl = BaseClass("UILWAllianceShopCtrl", UIBaseCtrl)

function UILWAllianceShopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceShop)
end

function UILWAllianceShopCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UILWAllianceShopCtrl
