local BuyDiamondPackTipsCtrl = BaseClass("BuyDiamondPackTipsCtrl", UIBaseCtrl)

function BuyDiamondPackTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BuyDiamondPackTips)
end

return BuyDiamondPackTipsCtrl
