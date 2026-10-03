local UIServerMaintenanceTipCtrl = BaseClass("UIServerMaintenanceTipCtrl", UIBaseCtrl)

function UIServerMaintenanceTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerMaintenanceTip, {anim = false})
end

function UIServerMaintenanceTipCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIServerMaintenanceTipCtrl
