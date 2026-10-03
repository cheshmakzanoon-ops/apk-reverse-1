local UIPackageContentTipCtrl = BaseClass("UIPackageContentTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPackageContentTip)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIPackageContentTipCtrl.CloseSelf = CloseSelf
UIPackageContentTipCtrl.Close = Close
return UIPackageContentTipCtrl
