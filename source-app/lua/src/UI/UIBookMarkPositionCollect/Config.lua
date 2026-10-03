local UIBookMarkPositionCollect = {
  Name = UIWindowNames.UIBookMarkPositionCollect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBookMarkPositionCollect.Controller.UIBookMarkPositionCollectCtrl"),
  View = require("UI.UIBookMarkPositionCollect.View.UIBookMarkPositionCollectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BookMark/UIBookMarkPositionCollect.prefab"
}
return {UIBookMarkPositionCollect = UIBookMarkPositionCollect}
