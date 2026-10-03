local FrontBreakOutSundayPatFaceCtrl = BaseClass("FrontBreakOutSundayPatFaceCtrl", UIBaseCtrl)

function FrontBreakOutSundayPatFaceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FrontBreakOutSundayPatFace)
end

return FrontBreakOutSundayPatFaceCtrl
