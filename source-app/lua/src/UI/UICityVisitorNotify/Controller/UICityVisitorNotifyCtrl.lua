local UICityVisitorNotifyCtrl = BaseClass("UICityVisitorNotifyCtrl", UIBaseCtrl)

local function CloseSelf(self, isNotShowMain)
  if isNotShowMain then
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitorNotify)
  end
end

UICityVisitorNotifyCtrl.CloseSelf = CloseSelf
return UICityVisitorNotifyCtrl
