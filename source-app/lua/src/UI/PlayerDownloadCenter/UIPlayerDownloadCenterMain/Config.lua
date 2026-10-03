local UIPlayerDownloadCenterMain = {
  Name = UIWindowNames.UIPlayerDownloadCenterMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Ctrl.UIPlayerDownloadCenterMainCtrl"),
  View = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.View.UIPlayerDownloadCenterMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterMain.prefab"
}
return {UIPlayerDownloadCenterMain = UIPlayerDownloadCenterMain}
