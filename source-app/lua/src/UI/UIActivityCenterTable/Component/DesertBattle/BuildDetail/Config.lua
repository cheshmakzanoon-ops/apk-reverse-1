local UIDesertBuildDetail = {
  Name = UIWindowNames.UIDesertBuildDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildDetail.Controller.UIDesertBuildDetailCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildDetail.View.UIDesertBuildDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BuildDetail.prefab"
}
return {UIDesertBuildDetail = UIDesertBuildDetail}
