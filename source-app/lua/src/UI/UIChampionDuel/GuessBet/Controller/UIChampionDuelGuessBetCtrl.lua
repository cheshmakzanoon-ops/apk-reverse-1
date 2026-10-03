local UIChampionDuelGuessBetCtrl = BaseClass("UIChampionDuelGuessBetCtrl", UIBaseCtrl)

function UIChampionDuelGuessBetCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelGuessBet)
end

return UIChampionDuelGuessBetCtrl
