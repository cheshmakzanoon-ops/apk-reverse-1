local UIFireworkQuickTipCtrl = BaseClass("UIFireworkQuickTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkQuickTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFireworkQuickTipCtrl.CloseSelf = CloseSelf
UIFireworkQuickTipCtrl.Close = Close
return UIFireworkQuickTipCtrl
