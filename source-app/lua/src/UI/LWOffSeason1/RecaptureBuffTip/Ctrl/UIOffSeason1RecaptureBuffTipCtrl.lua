local UIOffSeason1RecaptureBuffTipCtrl = BaseClass("UIOffSeason1RecaptureBuffTipCtrl", UIBaseCtrl)

function UIOffSeason1RecaptureBuffTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOffSeason1RecaptureBuffTip)
end

return UIOffSeason1RecaptureBuffTipCtrl
