local LWActivityPopCtrl = BaseClass("LWActivityPopCtrl", UIBaseCtrl)

function LWActivityPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityPop, {anim = false})
end

return LWActivityPopCtrl
