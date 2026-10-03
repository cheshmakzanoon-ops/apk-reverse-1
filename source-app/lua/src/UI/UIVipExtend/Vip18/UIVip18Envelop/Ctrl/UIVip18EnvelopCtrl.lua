local UIVip18EnvelopCtrl = BaseClass("UIVip18EnvelopCtrl", UIBaseCtrl)

function UIVip18EnvelopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVip18Envelop, {anim = false})
end

return UIVip18EnvelopCtrl
