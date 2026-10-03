local UIWorldPlaceAnything = {
  Name = UIWindowNames.UIWorldPlaceAnything,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldPlaceAnything.Controller.UIWorldPlaceAnythingCtrl"),
  View = require("UI.UIWorldPlaceAnything.View.UIWorldPlaceAnythingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldPlaceAnything.prefab"
}
return {UIWorldPlaceAnything = UIWorldPlaceAnything}
