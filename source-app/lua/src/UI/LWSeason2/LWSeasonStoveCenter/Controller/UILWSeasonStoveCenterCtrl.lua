local UILWSeasonStoveCenterCtrl = BaseClass("UILWSeasonStoveCenterCtrl", UIBaseCtrl)

function UILWSeasonStoveCenterCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonStoveCenter)
end

return UILWSeasonStoveCenterCtrl
