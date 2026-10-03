local UIWorldTileUI = {
  Name = UIWindowNames.UIWorldTileUI,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIWorldTileUI.Controller.UIWorldTileUICtrl"),
  View = require("UI.UIWorldTileUI.View.UIWorldTileUIView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldTileUI.prefab"
}
return {UIWorldTileUI = UIWorldTileUI}
