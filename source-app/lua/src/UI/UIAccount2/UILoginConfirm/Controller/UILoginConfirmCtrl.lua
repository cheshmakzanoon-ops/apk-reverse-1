local UILoginConfirmCtrlCtrl = BaseClass("UILoginConfirmCtrlCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILoginConfirm)
end

UILoginConfirmCtrlCtrl.CloseSelf = CloseSelf
return UILoginConfirmCtrlCtrl
