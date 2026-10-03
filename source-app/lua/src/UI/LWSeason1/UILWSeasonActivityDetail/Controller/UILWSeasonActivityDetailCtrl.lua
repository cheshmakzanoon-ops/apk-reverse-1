local UILWSeasonActivityDetailCtrl = BaseClass("UILWSeasonActivityDetailCtrl", UIBaseCtrl)

function UILWSeasonActivityDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonActivityDetail)
end

return UILWSeasonActivityDetailCtrl
