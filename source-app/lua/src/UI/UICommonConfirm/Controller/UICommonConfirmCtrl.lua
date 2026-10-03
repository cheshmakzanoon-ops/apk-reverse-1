local UICommonConfirmCtrl = BaseClass("UICommonConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
end

UICommonConfirmCtrl.CloseSelf = CloseSelf
return UICommonConfirmCtrl
