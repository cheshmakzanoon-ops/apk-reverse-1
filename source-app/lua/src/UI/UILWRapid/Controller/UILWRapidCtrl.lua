local UILWRapidCtrl = BaseClass("UILWRapidCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWRapid)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetQuickPackageInfo(self, speedType)
  local packageTb = GiftPackageData.GetAddTimePacks(speedType)
  if packageTb and 0 < #packageTb then
    return packageTb[1]
  end
end

local function BuyGift(self, info)
  DataCenter.PayManager:CallPayment(info, UIWindowNames.UIResourceBag)
end

UILWRapidCtrl.CloseSelf = CloseSelf
UILWRapidCtrl.Close = Close
UILWRapidCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UILWRapidCtrl.BuyGift = BuyGift
return UILWRapidCtrl
