local UIPlaceRoad = {
  Name = UIWindowNames.UIPlaceRoad,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPlaceRoad.Controller.UIPlaceRoadCtrl"),
  View = require("UI.UIPlaceRoad.View.UIPlaceRoadView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/UIPlaceRoad.prefab"
}
return {UIPlaceRoad = UIPlaceRoad}
