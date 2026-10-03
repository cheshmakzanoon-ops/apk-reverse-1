local UIGuideArrowCtrl = BaseClass("UIGuideArrowCtrl", UIBaseCtrl)

function UIGuideArrowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideArrow, {anim = false, playEffect = false})
end

return UIGuideArrowCtrl
