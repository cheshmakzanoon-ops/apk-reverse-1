local UIEpidemicBattleMap = {
  Name = UIWindowNames.UIEpidemicBattleMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleMap.Controller.UIEpidemicBattleMapCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleMap.View.UIEpidemicBattleMapView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleMap.prefab"
}
return {UIEpidemicBattleMap = UIEpidemicBattleMap}
