local UIStorageShopRetrieveNewCtrl = BaseClass("UIStorageShopRetrieveNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStorageShopRetrieveNew)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIStorageShopRetrieveNewCtrl.CloseSelf = CloseSelf
UIStorageShopRetrieveNewCtrl.Close = Close
return UIStorageShopRetrieveNewCtrl
