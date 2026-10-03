local UILWSeasonVirusHistory = {
  Name = UIWindowNames.UILWSeasonVirusHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonVirusHistory.Controller.UILWSeasonVirusHistoryCtrl"),
  View = require("UI.LWSeason1.UILWSeasonVirusHistory.View.UILWSeasonVirusHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/VirusHistory.prefab"
}
return {UILWSeasonVirusHistory = UILWSeasonVirusHistory}
