local UIChampionDuelSignTipCtrl = BaseClass("UIChampionDuelSignTipCtrl", UIBaseCtrl)

function UIChampionDuelSignTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelSignTip)
end

return UIChampionDuelSignTipCtrl
