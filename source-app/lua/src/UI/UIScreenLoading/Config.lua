local UIMoving = {
  Name = UIWindowNames.UIScreenLoading,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScreenLoading.Controller.UIScreenLoadingCtrl"),
  View = require("UI.UIScreenLoading.View.UIScreenLoadingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIScreenLoading.prefab"
}
return {UIMoving = UIMoving}
