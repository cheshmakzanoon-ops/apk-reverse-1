local UIEarthOrderTipCtrl = BaseClass("UIEarthOrderTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEarthOrderTip)
end

UIEarthOrderTipCtrl.CloseSelf = CloseSelf
return UIEarthOrderTipCtrl
