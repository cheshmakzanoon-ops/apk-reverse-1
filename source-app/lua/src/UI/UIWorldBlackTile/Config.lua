local UIWorldBlackTile = {
  Name = UIWindowNames.UIWorldBlackTile,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldBlackTile.Controller.UIWorldBlackTileCtrl"),
  View = require("UI.UIWorldBlackTile.View.UIWorldBlackTileView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISearch/UIWorldBlackTile.prefab"
}
return {UIWorldBlackTile = UIWorldBlackTile}
