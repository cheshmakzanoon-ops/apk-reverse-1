local UICommonIntroTipCtrl = BaseClass("UICommonIntroTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonIntroTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonIntroTipCtrl.CloseSelf = CloseSelf
UICommonIntroTipCtrl.Close = Close
return UICommonIntroTipCtrl
