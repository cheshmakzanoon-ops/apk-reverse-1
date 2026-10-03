local UILWBiuBiuPveResultCtrl = BaseClass("UILWBiuBiuPveResultCtrl", UIBaseCtrl)

function UILWBiuBiuPveResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPveResult)
end

return UILWBiuBiuPveResultCtrl
