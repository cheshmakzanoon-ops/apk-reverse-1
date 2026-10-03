local UIWinterStormTaskS0Ctrl = BaseClass("UIWinterStormTaskS0Ctrl", UIBaseCtrl)

function UIWinterStormTaskS0Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormTaskS0)
end

return UIWinterStormTaskS0Ctrl
