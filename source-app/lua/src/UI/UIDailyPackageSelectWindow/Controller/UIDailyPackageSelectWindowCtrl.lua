local UIDailyPackageSelectWindowCtrl = BaseClass("UIDailyPackageSelectWindowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDailyPackageSelectWindow)
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function Close(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDailyPackageSelectWindow)
  DataCenter.ArrowManager:RemoveFingerArrow()
end

UIDailyPackageSelectWindowCtrl.CloseSelf = CloseSelf
UIDailyPackageSelectWindowCtrl.Close = Close
UIDailyPackageSelectWindowCtrl.BuyGift = BuyGift
return UIDailyPackageSelectWindowCtrl
