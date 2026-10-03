local UIChampionDuelDetailInfoCtrl = BaseClass("UIChampionDuelDetailInfoCtrl", UIBaseCtrl)

function UIChampionDuelDetailInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelDetailInfo)
end

return UIChampionDuelDetailInfoCtrl
