local UILWSeasonS6CrossOccupyDetailCtrl = BaseClass("UILWSeasonS6CrossOccupyDetailCtrl", UIBaseCtrl)

function UILWSeasonS6CrossOccupyDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonS6CrossOccupyDetail)
end

return UILWSeasonS6CrossOccupyDetailCtrl
