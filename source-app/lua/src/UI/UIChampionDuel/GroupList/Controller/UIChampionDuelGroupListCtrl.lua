local UIChampionDuelGroupListCtrl = BaseClass("UIChampionDuelGroupListCtrl", UIBaseCtrl)

function UIChampionDuelGroupListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelGroupList)
end

return UIChampionDuelGroupListCtrl
