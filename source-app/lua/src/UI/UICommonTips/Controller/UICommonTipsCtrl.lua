local UICommonTipsCtrl = BaseClass("UICommonTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTips)
end

UICommonTipsCtrl.CloseSelf = CloseSelf
return UICommonTipsCtrl
