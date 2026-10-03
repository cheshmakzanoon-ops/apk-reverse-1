local UIMainMiniMap = {
  Name = UIWindowNames.UIMainMiniMap,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainMiniMap.Controller.UIMainMiniMapCtrl"),
  View = require("UI.UIMainMiniMap.View.UIMainMiniMapView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/UIMainMapPoint.prefab",
  IgnoreDestroyWindowByLayer = true,
  CustomKeyCodeEscape = true
}
return {UIMainMiniMap = UIMainMiniMap}
