local UISpeedCtrl = BaseClass("UISpeedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISpeed)
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

local function IsDailyMustBuyPackage(self, packageInfo)
  local tagData = WelfareController.getShowTagInfoByType(WelfareTagType.DailyMustBuy)
  if tagData ~= nil then
    local packageList = tagData:getInfo()
    if 0 < #packageList then
      for _, v in pairs(packageList) do
        if packageInfo:getID() == v:getID() then
          return true
        end
      end
    end
  end
  return false
end

UISpeedCtrl.CloseSelf = CloseSelf
UISpeedCtrl.Close = Close
UISpeedCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UISpeedCtrl.BuyGift = BuyGift
UISpeedCtrl.IsDailyMustBuyPackage = IsDailyMustBuyPackage
return UISpeedCtrl
