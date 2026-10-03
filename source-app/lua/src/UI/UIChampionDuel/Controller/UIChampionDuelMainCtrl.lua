local UIChampionDuelMainCtrl = BaseClass("UIChampionDuelMainCtrl", UIBaseCtrl)

function UIChampionDuelMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelMain, {anim = false})
end

function UIChampionDuelMainCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIChampionDuelMainCtrl
