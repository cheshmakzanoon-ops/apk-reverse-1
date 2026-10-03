local Season5DeclareCityList = {
  Name = UIWindowNames.Season5DeclareCityList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.DeclareCity.Season5DeclareCityList.Controller.Season5DeclareCityListCtrl"),
  View = require("UI.LWSeason5.DeclareCity.Season5DeclareCityList.View.Season5DeclareCityListView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/DeclareCityS5/S5DeclareCityList.prefab"
}
return {Season5DeclareCityList = Season5DeclareCityList}
