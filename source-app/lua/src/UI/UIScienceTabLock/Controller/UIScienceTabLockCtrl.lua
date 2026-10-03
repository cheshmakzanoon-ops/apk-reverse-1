local UIScienceTabLockCtrl = BaseClass("UIScienceTabLockCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIScienceTabLock)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIScienceTabLockCtrl.CloseSelf = CloseSelf
UIScienceTabLockCtrl.Close = Close
return UIScienceTabLockCtrl
