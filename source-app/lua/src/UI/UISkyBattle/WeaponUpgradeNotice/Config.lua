local SkyBattleWeaponUpgradeNotice = {
  Name = UIWindowNames.SkyBattleWeaponUpgradeNotice,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkyBattle.WeaponUpgradeNotice.SkyBattleWeaponUpgradeNoticeCtrl"),
  View = require("UI.UISkyBattle.WeaponUpgradeNotice.SkyBattleWeaponUpgradeNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SkyBattle/SkyBattleWeaponUpgradeNotice.prefab"
}
return {SkyBattleWeaponUpgradeNotice = SkyBattleWeaponUpgradeNotice}
