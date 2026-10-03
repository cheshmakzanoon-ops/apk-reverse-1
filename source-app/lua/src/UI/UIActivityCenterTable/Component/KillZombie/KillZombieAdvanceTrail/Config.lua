local UIKillZombieAdvanceTrail = {
  Name = UIWindowNames.UIKillZombieAdvanceTrail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieAdvanceTrail.Controller.UIKillZombieAdvanceTrailCtrl"),
  View = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieAdvanceTrail.View.UIKillZombieAdvanceTrailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIActivityTipOpenAdvanceTrail.prefab"
}
return {UIKillZombieAdvanceTrail = UIKillZombieAdvanceTrail}
