local LWSeasonBossDamageTip = {
  Name = UIWindowNames.LWSeasonBossDamageTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.LWSeasonBossDamageTip.Controller.LWSeasonBossDamageTipCtrl"),
  View = require("UI.LWSeason1.LWSeasonBossDamageTip.View.LWSeasonBossDamageTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/BossLogin/LWSeasonBossDamageTip.prefab",
  HideInBattle = true
}
return {LWSeasonBossDamageTip = LWSeasonBossDamageTip}
