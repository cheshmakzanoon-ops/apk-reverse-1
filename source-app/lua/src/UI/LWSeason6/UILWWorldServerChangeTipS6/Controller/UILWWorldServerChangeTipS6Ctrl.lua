local UILWWorldServerChangeTipS6Ctrl = BaseClass("UILWWorldServerChangeTipS6Ctrl", UIBaseCtrl)

function UILWWorldServerChangeTipS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWWorldServerChangeTipS6, {anim = false})
end

return UILWWorldServerChangeTipS6Ctrl
