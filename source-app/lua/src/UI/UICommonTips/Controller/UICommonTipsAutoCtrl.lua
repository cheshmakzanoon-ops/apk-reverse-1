local UICommonTipsAutoCtrl = BaseClass("UICommonTipsAutoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTipsAuto)
end

UICommonTipsAutoCtrl.CloseSelf = CloseSelf
return UICommonTipsAutoCtrl
