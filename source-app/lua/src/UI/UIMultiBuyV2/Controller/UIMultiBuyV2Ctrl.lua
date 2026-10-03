local UIMultiBuyV2Ctrl = BaseClass("UIMultiBuyV2Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMultiBuyV2)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMultiBuyV2Ctrl.CloseSelf = CloseSelf
UIMultiBuyV2Ctrl.Close = Close
return UIMultiBuyV2Ctrl
