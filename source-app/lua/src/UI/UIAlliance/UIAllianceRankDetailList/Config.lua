local UIAllianceRankDetailList = {
  Name = UIWindowNames.UIAllianceRankDetailList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceRankDetailList.Controller.UIAllianceRankDetailListCtrl"),
  View = require("UI.UIAlliance.UIAllianceRankDetailList.View.UIAllianceRankDetailListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceRankDetailList.prefab"
}
return {UIAllianceRankDetailList = UIAllianceRankDetailList}
