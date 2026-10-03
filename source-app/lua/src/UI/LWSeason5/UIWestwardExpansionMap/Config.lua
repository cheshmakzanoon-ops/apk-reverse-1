local UIWestwardExpansionMap = {
  Name = UIWindowNames.UIWestwardExpansionMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UIWestwardExpansionMap.Controller.UIWestwardExpansionMapCtrl"),
  View = require("UI.LWSeason5.UIWestwardExpansionMap.View.UIWestwardExpansionMapView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/WestwardExpansion/UIWestwardExpansionMap.prefab"
}
return {UIWestwardExpansionMap = UIWestwardExpansionMap}
