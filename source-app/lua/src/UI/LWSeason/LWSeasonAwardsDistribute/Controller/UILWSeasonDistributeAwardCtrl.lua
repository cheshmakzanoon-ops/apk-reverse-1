local UILWSeasonDistributeAwardCtrl = BaseClass("UILWSeasonDistributeAwardCtrl", UIBaseCtrl)

function UILWSeasonDistributeAwardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonDistributeAward)
end

return UILWSeasonDistributeAwardCtrl
