local UIMultiBuyCtrl = BaseClass("UIMultiBuyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMultiBuy)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMultiBuyCtrl.CloseSelf = CloseSelf
UIMultiBuyCtrl.Close = Close
return UIMultiBuyCtrl
