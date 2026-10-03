local UIPathArrowCtrl = BaseClass("UIPathArrowCtrl", UIBaseCtrl)

function UIPathArrowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPathArrow, {anim = false, playEffect = false})
end

return UIPathArrowCtrl
