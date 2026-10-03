local UILWSeasonCrossOccupyDetailCtrl = BaseClass("UILWSeasonCrossOccupyDetailCtrl", UIBaseCtrl)

function UILWSeasonCrossOccupyDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCrossOccupyDetail)
end

return UILWSeasonCrossOccupyDetailCtrl
