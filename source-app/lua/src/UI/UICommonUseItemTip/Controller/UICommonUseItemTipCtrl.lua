local UICommonUseItemTipCtrl = BaseClass("UICommonUseItemTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonUseItemTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonUseItemTipCtrl.CloseSelf = CloseSelf
UICommonUseItemTipCtrl.Close = Close
return UICommonUseItemTipCtrl
