local UIAccountSetConfirmCtrl = BaseClass("UIAccountSetConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountSetConfirm)
end

UIAccountSetConfirmCtrl.CloseSelf = CloseSelf
return UIAccountSetConfirmCtrl
