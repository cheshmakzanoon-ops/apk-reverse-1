local UIItemRevertCtrl = BaseClass("UIItemRevertCtrl", UIBaseCtrl)

function UIItemRevertCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemRevert)
end

return UIItemRevertCtrl
