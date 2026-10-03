local SeasonDeclareCityDetail = {
  Name = UIWindowNames.SeasonDeclareCityDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityDetail.Controller.SeasonDeclareCityDetailCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityDetail.View.SeasonDeclareCityDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/DeclareCity/DeclareCityDetail.prefab"
}
return {SeasonDeclareCityDetail = SeasonDeclareCityDetail}
