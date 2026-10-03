local UILWGGGoPveResultCtrl = BaseClass("UILWGGGoPveResultCtrl", UIBaseCtrl)

function UILWGGGoPveResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPveResult)
end

return UILWGGGoPveResultCtrl
