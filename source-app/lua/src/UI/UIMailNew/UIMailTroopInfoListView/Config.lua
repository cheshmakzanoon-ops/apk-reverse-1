local UIMailTroopInfoListView = {
  Name = UIWindowNames.UIMailTroopInfoListView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailTroopInfoListView.Controller.UIMailTroopInfoListCtrl"),
  View = require("UI.UIMailNew.UIMailTroopInfoListView.View.UIMailTroopInfoListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/TroopInfoList/UIMailTroopInfoList.prefab"
}
return {UIMailTroopInfoListView = UIMailTroopInfoListView}
