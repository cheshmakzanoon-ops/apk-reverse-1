local AllyDrillUpdateBoss = {
  Name = UIWindowNames.AllyDrillUpdateBoss,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActAllyDrillUpdateBoss.AllyDrillUpdateBossTipCtrl"),
  View = require("UI.UIActAllyDrillUpdateBoss.AllyDrillUpdateBossTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillUpdateBossTip.prefab"
}
return {AllyDrillUpdateBoss = AllyDrillUpdateBoss}
