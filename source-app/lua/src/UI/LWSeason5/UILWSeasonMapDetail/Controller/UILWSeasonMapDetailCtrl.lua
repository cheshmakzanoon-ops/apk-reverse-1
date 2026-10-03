local UILWSeasonMapDetailCtrl = BaseClass("UILWSeasonMapDetailCtrl", UIBaseCtrl)

function UILWSeasonMapDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMapDetail)
end

return UILWSeasonMapDetailCtrl
