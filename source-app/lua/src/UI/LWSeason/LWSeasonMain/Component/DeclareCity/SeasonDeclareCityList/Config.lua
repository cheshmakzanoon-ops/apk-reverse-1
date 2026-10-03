local SeasonDeclareCityList = {
  Name = UIWindowNames.SeasonDeclareCityList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityList.Controller.SeasonDeclareCityListCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityList.View.SeasonDeclareCityListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/DeclareCity/DeclareCityList.prefab"
}
return {SeasonDeclareCityList = SeasonDeclareCityList}
