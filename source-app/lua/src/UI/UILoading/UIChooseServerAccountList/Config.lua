local UIChooseServerAccountList = {
  Name = UIWindowNames.UIChooseServerAccountList,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILoading.UIChooseServerAccountList.Controller.UIChooseServerAccountListCtrl"),
  View = require("UI.UILoading.UIChooseServerAccountList.View.UIChooseServerAccountListView"),
  PrefabPath = "Assets/Main/Prefabs/Debug/UIChooseServerAccountList.prefab"
}
return {UIChooseServerAccountList = UIChooseServerAccountList}
