local Season5DeclareWarTimeView = {
  Name = UIWindowNames.Season5DeclareWarTimeView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.DeclareCity.Season5DeclareCityWarTime.Ctrl.Season5DeclareWarTimeCtrl"),
  View = require("UI.LWSeason5.DeclareCity.Season5DeclareCityWarTime.View.Season5DeclareWarTimeView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/DeclareCityS5/S5DeclareCityWarTimeView.prefab"
}
return {Season5DeclareWarTimeView = Season5DeclareWarTimeView}
