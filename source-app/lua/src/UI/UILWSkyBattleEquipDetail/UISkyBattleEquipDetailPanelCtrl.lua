local UISkyBattleEquipDetailPanelCtrl = BaseClass("UISkyBattleEquipDetailPanelCtrl", UIBaseCtrl)

function UISkyBattleEquipDetailPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattlePlaneEquipDetail)
end

return UISkyBattleEquipDetailPanelCtrl
