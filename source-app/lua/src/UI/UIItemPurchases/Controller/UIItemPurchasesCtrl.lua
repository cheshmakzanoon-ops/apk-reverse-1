local UIItemPurchasesCtrl = BaseClass("UIItemPurchasesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemPurchases)
end

local function GetQuickPackageInfo(self, itemId)
  local packageTb = GiftPackageData.GetGivenPacks(itemId)
  if packageTb and 0 < #packageTb then
    return packageTb[1]
  end
end

local function BuyGift(self, info)
  DataCenter.PayManager:CallPayment(info, UIWindowNames.UIItemPurchases)
end

UIItemPurchasesCtrl.CloseSelf = CloseSelf
UIItemPurchasesCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UIItemPurchasesCtrl.BuyGift = BuyGift
return UIItemPurchasesCtrl
