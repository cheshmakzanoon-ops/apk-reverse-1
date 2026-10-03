local UIPlayerDownloadCenterDeleteList = {
  Name = UIWindowNames.UIPlayerDownloadCenterDeleteList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterDeleteList.Ctrl.UIPlayerDownloadCenterDeleteListCtrl"),
  View = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterDeleteList.View.UIPlayerDownloadCenterDeleteListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterDeleteList.prefab"
}
return {UIPlayerDownloadCenterDeleteList = UIPlayerDownloadCenterDeleteList}
