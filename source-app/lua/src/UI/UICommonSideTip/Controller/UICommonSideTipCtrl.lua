local UICommonSideTipCtrl = BaseClass("UICommonSideTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSideTip, {anim = false})
end

UICommonSideTipCtrl.CloseSelf = CloseSelf
return UICommonSideTipCtrl
