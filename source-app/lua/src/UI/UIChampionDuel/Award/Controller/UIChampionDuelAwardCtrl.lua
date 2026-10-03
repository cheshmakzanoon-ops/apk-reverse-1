local UIChampionDuelAwardCtrl = BaseClass("UIChampionDuelAwardCtrl", UIBaseCtrl)

function UIChampionDuelAwardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelAward)
end

return UIChampionDuelAwardCtrl
