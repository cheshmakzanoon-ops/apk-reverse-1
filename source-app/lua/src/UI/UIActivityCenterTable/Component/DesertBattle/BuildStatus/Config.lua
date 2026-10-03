local UIDesertBuildStatus = {
  Name = UIWindowNames.UIDesertBuildStatus,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildStatus.Controller.UIDesertBuildStatusCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.BuildStatus.View.UIDesertBuildStatusView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/BuildStatus.prefab"
}
return {UIDesertBuildStatus = UIDesertBuildStatus}
