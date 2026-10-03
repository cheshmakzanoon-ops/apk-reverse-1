local UIChampionDuelFinalListCtrl = BaseClass("UIChampionDuelFinalListCtrl", UIBaseCtrl)

function UIChampionDuelFinalListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelFinalList, {anim = false})
end

function UIChampionDuelFinalListCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIChampionDuelFinalListCtrl
