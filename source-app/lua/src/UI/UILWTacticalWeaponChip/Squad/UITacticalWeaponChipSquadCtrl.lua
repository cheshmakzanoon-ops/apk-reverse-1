local UITacticalWeaponChipSquadCtrl = BaseClass("UITacticalWeaponChipSquadCtrl", UIBaseCtrl)

function UITacticalWeaponChipSquadCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponChipSquad)
end

return UITacticalWeaponChipSquadCtrl
