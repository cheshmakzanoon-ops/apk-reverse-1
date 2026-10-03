local UICommonSimpleShareConfirmCtrl = BaseClass("UICommonSimpleShareConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSimpleShareConfirm)
end

UICommonSimpleShareConfirmCtrl.CloseSelf = CloseSelf
return UICommonSimpleShareConfirmCtrl
