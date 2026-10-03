local LWUIWorldBossDamageTipView = {
  Name = UIWindowNames.LWUIWorldBossDamageTipView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossDamageTip.Ctrl.LWUIWorldBossDamageTipCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossDamageTip.View.LWUIWorldBossDamageTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WorldBoss/UIWorldBossDamageTip.prefab",
  HideInBattle = true
}
return {LWUIWorldBossDamageTipView = LWUIWorldBossDamageTipView}
