local LWBuyDiamondPopCtrl = BaseClass("LWBuyDiamondPopCtrl", UIBaseCtrl)

function LWBuyDiamondPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWBuyDiamondPop, {anim = false})
end

return LWBuyDiamondPopCtrl
