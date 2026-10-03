local UIStorageShopRetrieveCtrl = BaseClass("UIStorageShopRetrieveCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStorageShopRetrieve)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIStorageShopRetrieveCtrl.CloseSelf = CloseSelf
UIStorageShopRetrieveCtrl.Close = Close
return UIStorageShopRetrieveCtrl
