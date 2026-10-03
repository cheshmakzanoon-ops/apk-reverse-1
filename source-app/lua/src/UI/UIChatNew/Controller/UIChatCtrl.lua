local UIChatCtrl = BaseClass("UIChatCtrl", UIBaseCtrl)

function UIChatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew, {anim = true, playEffect = false})
end

return UIChatCtrl
