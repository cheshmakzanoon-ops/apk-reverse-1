local UIChampionDuelFormationTipsCtrl = BaseClass("UIChampionDuelFormationTipsCtrl", UIBaseCtrl)

function UIChampionDuelFormationTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelFormationTips, {anim = true})
end

return UIChampionDuelFormationTipsCtrl
