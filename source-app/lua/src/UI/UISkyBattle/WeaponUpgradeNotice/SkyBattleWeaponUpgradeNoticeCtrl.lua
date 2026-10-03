local SkyBattleWeaponUpgradeNoticeCtrl = BaseClass("SkyBattleWeaponUpgradeNoticeCtrl", UIBaseCtrl)

function SkyBattleWeaponUpgradeNoticeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SkyBattleWeaponUpgradeNotice)
end

return SkyBattleWeaponUpgradeNoticeCtrl
