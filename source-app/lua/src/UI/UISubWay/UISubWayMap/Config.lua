local UISubWayMap = {
  Name = UIWindowNames.UISubWayMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISubWay.UISubWayMap.Controller.UISubWayMapCtrl"),
  View = require("UI.UISubWay.UISubWayMap.View.UISubWayMapView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISubWay/UISubWayMap.prefab"
}
return {WorldDesUI = UISubWayMap}
