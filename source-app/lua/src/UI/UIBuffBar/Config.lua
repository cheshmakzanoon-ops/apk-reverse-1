local UIBuffBar = {
  Name = UIWindowNames.UIBuffBar,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuffBar.Controller.UIBuffBarCtrl"),
  View = require("UI.UIBuffBar.View.UIBuffBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BuffBar/BuffBarPanel.prefab"
}
return {UIBuffBar = UIBuffBar}
