local UILWT11IdleGameGuideCtrl = BaseClass("UILWT11IdleGameGuideCtrl", UIBaseCtrl)

function UILWT11IdleGameGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameGuide)
end

return UILWT11IdleGameGuideCtrl
