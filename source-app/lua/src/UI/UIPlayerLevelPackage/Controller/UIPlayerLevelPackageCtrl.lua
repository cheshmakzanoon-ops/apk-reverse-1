local UIFirstPayCtrl = BaseClass("UIFirstPayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPlayerLevelPackage)
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function Close(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPlayerLevelPackage)
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function BuyGift(self, info)
  DataCenter.PayManager:CallPayment(info, UIWindowNames.UIPlayerLevelPackage)
end

UIFirstPayCtrl.CloseSelf = CloseSelf
UIFirstPayCtrl.Close = Close
UIFirstPayCtrl.BuyGift = BuyGift
return UIFirstPayCtrl
