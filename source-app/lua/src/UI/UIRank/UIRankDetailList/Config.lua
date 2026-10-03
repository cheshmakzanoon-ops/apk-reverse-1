local UIRankDetailList = {
  Name = UIWindowNames.UIRankDetailList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRank.UIRankDetailList.Controller.UIRankDetailListCtrl"),
  View = require("UI.UIRank.UIRankDetailList.View.UIRankDetailListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/UIRankDetailList.prefab"
}
return {UIRankDetailList = UIRankDetailList}
