local UIPlayerDownloadCenterProgressList = {
  Name = UIWindowNames.UIPlayerDownloadCenterProgressList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterProgressList.Ctrl.UIPlayerDownloadCenterProgressListCtrl"),
  View = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterProgressList.View.UIPlayerDownloadCenterProgressListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterProgressList.prefab"
}
return {UIPlayerDownloadCenterProgressList = UIPlayerDownloadCenterProgressList}
