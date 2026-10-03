local UIVIPRenewCtrl = BaseClass("UIVIPRenewCtrl", UIBaseCtrl)

function UIVIPRenewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVIPRewnew)
end

function UIVIPRenewCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIVIPRenewCtrl
