local UIAllianceApplyList = {
  Name = UIWindowNames.UIAllianceApplyList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceApplyList.Controller.UIAllianceApplyListCtrl"),
  View = require("UI.UIAlliance.UIAllianceApplyList.View.UIAllianceApplyListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceApplyList.prefab"
}
return {UIAllianceApplyList = UIAllianceApplyList}
