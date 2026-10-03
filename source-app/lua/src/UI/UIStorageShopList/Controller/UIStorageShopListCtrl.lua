local UIStorageShopListCtrl = BaseClass("UIStorageShopListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStorageShopList)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIStorageShopListCtrl.CloseSelf = CloseSelf
UIStorageShopListCtrl.Close = Close
return UIStorageShopListCtrl
