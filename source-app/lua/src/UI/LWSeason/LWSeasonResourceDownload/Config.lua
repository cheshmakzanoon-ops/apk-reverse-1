local LWSeasonDistributeReward = {
  Name = UIWindowNames.UILWSeasonResourceDownload,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonResourceDownload.Controller.UILWSeasonResourceDownloadCtrl"),
  View = require("UI.LWSeason.LWSeasonResourceDownload.View.UILWSeasonResourceDownloadView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/UISeasonResourceDownload.prefab"
}
return {LWSeasonDistributeReward = LWSeasonDistributeReward}
