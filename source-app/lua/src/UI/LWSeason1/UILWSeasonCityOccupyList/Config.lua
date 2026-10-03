local UILWSeasonCityOccupyList = {
  Name = UIWindowNames.UILWSeasonCityOccupyList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonCityOccupyList.Controller.UILWSeasonCityOccupyListCtrl"),
  View = require("UI.LWSeason1.UILWSeasonCityOccupyList.View.UILWSeasonCityOccupyListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/UICityOccupyList.prefab",
  HideBack = true
}
return {UILWSeasonCityOccupyList = UILWSeasonCityOccupyList}
