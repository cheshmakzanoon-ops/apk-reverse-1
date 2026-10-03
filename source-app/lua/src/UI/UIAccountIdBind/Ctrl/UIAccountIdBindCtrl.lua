local UIAccountIdBindCtrl = BaseClass("UIAccountIdBindCtrl", UIBaseCtrl)

function UIAccountIdBindCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountIdBind)
end

return UIAccountIdBindCtrl
