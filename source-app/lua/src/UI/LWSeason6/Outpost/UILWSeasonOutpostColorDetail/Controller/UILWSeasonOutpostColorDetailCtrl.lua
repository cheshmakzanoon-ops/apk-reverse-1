local UILWSeasonOutpostColorDetailCtrl = BaseClass("UILWSeasonOutpostColorDetailCtrl", UIBaseCtrl)

function UILWSeasonOutpostColorDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostColorDetail)
end

return UILWSeasonOutpostColorDetailCtrl
