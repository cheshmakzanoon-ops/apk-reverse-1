local SeasonDeclareCityHistory = {
  Name = UIWindowNames.SeasonDeclareCityHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityHistory.Controller.SeasonDeclareCityHistoryCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityHistory.View.SeasonDeclareCityHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/DeclareCity/DeclareCityHistory.prefab"
}
return {SeasonDeclareCityHistory = SeasonDeclareCityHistory}
