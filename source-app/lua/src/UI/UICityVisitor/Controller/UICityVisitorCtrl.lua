local UICityVisitorCtrl = BaseClass("UIcityVisitorCtrl", UIBaseCtrl)

local function CloseSelf(self, isNotShowMain)
  if isNotShowMain then
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor)
  end
end

UICityVisitorCtrl.CloseSelf = CloseSelf
return UICityVisitorCtrl
