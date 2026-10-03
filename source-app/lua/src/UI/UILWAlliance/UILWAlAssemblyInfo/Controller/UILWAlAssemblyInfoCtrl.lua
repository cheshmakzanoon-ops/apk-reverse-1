local UILWAlAssemblyInfoCtrl = BaseClass("UILWAlAssemblyInfoCtrl", UIBaseCtrl)

function UILWAlAssemblyInfoCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAlAssemblyInfo)
end

return UILWAlAssemblyInfoCtrl
