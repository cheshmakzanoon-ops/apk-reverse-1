local UIChampionDuelGuessListCtrl = BaseClass("UIChampionDuelGuessListCtrl", UIBaseCtrl)

function UIChampionDuelGuessListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelGuessList)
end

return UIChampionDuelGuessListCtrl
