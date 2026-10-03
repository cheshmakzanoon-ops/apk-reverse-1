local UIWinterStormHistoryS0Ctrl = BaseClass("UIWinterStormHistoryS0Ctrl", UIBaseCtrl)

function UIWinterStormHistoryS0Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWinterStormHistoryS0)
end

return UIWinterStormHistoryS0Ctrl
