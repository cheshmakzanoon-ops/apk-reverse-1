local UIItemRevertConfirmCtrl = BaseClass("UIItemRevertConfirmCtrl", UIBaseCtrl)

function UIItemRevertConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemRevertConfirm)
end

return UIItemRevertConfirmCtrl
