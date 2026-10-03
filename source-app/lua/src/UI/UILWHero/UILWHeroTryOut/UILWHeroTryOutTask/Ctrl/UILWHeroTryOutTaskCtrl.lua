local UILWHeroTryOutTaskCtrl = BaseClass("UILWHeroTryOutTaskCtrl", UIBaseCtrl)

function UILWHeroTryOutTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWHeroTryOutTask)
end

return UILWHeroTryOutTaskCtrl
