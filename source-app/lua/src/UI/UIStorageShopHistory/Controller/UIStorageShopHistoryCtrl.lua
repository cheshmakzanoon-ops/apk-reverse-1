local UIStorageShopHistoryCtrl = BaseClass("UIStorageShopHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIStorageShopHistory)
end

UIStorageShopHistoryCtrl.CloseSelf = CloseSelf
return UIStorageShopHistoryCtrl
