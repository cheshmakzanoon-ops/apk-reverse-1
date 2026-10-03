local UIPondCtrl = BaseClass("UIPondCtrl", UIBaseCtrl)

function UIPondCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPond)
end

return UIPondCtrl
