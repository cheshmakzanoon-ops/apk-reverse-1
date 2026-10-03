local Ctrl = BaseClass("Ctrl", UIBaseCtrl)

function Ctrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMainMailTipsPanel)
end

return Ctrl
