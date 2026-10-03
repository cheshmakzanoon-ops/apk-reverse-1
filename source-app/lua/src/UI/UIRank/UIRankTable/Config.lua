local UIRankTable = {
  Name = UIWindowNames.UIRankTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRank.UIRankTable.Controller.UIRankTableCtrl"),
  View = require("UI.UIRank.UIRankTable.View.UIRankTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/UIRankTable.prefab"
}
return {UIRankTable = UIRankTable}
