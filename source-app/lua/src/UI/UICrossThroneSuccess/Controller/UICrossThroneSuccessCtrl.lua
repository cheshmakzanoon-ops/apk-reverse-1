local UICrossThroneSuccessCtrl = BaseClass("UICrossThroneSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UICrossThroneSuccess)
end

UICrossThroneSuccessCtrl.CloseSelf = CloseSelf
return UICrossThroneSuccessCtrl
