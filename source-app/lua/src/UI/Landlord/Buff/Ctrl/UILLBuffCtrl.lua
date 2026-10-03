local UILLBuffCtrl = BaseClass("UILLBuffCtrl", UIBaseCtrl)

function UILLBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLBuff)
end

return UILLBuffCtrl
