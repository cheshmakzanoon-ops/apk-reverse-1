local UILWSeasonIntroductionCtrl = BaseClass("UILWSeasonIntroductionCtrl", UIBaseCtrl)

function UILWSeasonIntroductionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonIntroduction)
end

return UILWSeasonIntroductionCtrl
