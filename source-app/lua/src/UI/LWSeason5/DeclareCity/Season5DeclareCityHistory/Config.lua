local Season5DeclareCityHistory = {
  Name = UIWindowNames.Season5DeclareCityHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.DeclareCity.Season5DeclareCityHistory.Controller.Season5DeclareCityHistoryCtrl"),
  View = require("UI.LWSeason5.DeclareCity.Season5DeclareCityHistory.View.Season5DeclareCityHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/DeclareCityS5/S5DeclareCityHistory.prefab"
}
return {Season5DeclareCityHistory = Season5DeclareCityHistory}
