local UIChampionDuelDetailCtrl = BaseClass("UIChampionDuelDetailCtrl", UIBaseCtrl)

function UIChampionDuelDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelDetail)
end

return UIChampionDuelDetailCtrl
