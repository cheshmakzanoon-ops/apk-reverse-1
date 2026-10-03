local UIDesertBattleDetail = {
  Name = UIWindowNames.UIDesertBattleDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.Detail.Controller.UIDesertBattleDetailCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.Detail.View.UIDesertBattleDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Detail.prefab"
}
return {UIDesertBattleDetail = UIDesertBattleDetail}
