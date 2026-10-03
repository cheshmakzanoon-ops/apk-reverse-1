local UIPositionFavorite = {
  Name = UIWindowNames.UIPositionFavorite,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPositionFavorite.Controller.UIPositionFavoriteCtrl"),
  View = require("UI.UIPositionFavorite.View.UIPositionFavoriteView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionFavorite.prefab"
}
return {UIPositionFavorite = UIPositionFavorite}
