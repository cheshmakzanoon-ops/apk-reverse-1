local KillZombieBoxUpgrade = {
  Name = UIWindowNames.KillZombieBoxUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.KillZombie.BoxUpgrade.Ctrl.UIKillZombieBoxUpgradeCtrl"),
  View = require("UI.KillZombie.BoxUpgrade.View.UIKillZombieBoxUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIKillZombieBoxUpgrade.prefab",
  HideBack = true
}
return {KillZombieBoxUpgrade = KillZombieBoxUpgrade}
