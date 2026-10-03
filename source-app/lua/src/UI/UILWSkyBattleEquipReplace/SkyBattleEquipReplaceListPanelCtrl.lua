local SkyBattleEquipReplaceListPanelCtrl = BaseClass("SkyBattleEquipReplaceListPanelCtrl", UIBaseCtrl)

function SkyBattleEquipReplaceListPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SkyBattleEquipReplaceListPanel)
end

return SkyBattleEquipReplaceListPanelCtrl
