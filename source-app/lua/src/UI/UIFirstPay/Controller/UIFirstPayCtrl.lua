local UIFirstPayCtrl = BaseClass("UIFirstPayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFirstPay, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function BuyGift(self, info)
  if not info then
    return
  end
  DataCenter.PayManager:CallPayment(info, UIWindowNames.UIFirstPay)
  self:CloseSelf()
end

UIFirstPayCtrl.CloseSelf = CloseSelf
UIFirstPayCtrl.Close = Close
UIFirstPayCtrl.BuyGift = BuyGift
return UIFirstPayCtrl
