local UILWSeasonCityOccupyDetail = {
  Name = UIWindowNames.UILWSeasonCityOccupyDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWSeasonCityOccupyDetail.Controller.UILWSeasonCityOccupyDetailCtrl"),
  View = require("UI.LWSeason1.UILWSeasonCityOccupyDetail.View.UILWSeasonCityOccupyDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/UICityOccupyDetail.prefab"
}
return {UILWSeasonCityOccupyDetail = UILWSeasonCityOccupyDetail}
