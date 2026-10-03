local UILWAlSwitchJobCtrl = BaseClass("UILWAlSwitchJobCtrl", UIBaseCtrl)

function UILWAlSwitchJobCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlSwitchJob)
end

return UILWAlSwitchJobCtrl
