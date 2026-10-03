local UIActGiftBoxKeyAccessCtrl = BaseClass("UIActGiftBoxKeyAccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UICommonAccessBigPanel)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIActGiftBoxKeyAccessCtrl.CloseSelf = CloseSelf
UIActGiftBoxKeyAccessCtrl.Close = Close
return UIActGiftBoxKeyAccessCtrl
