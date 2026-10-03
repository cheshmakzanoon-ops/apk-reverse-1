local UIFarmAction = {
  Name = UIWindowNames.UIFarmAction,
  Layer = UILayer.Background,
  Ctrl = require("UI.UICityScene.UIFarmAction.Controller.UIFarmActionCtrl"),
  View = require("UI.UICityScene.UIFarmAction.View.UIFarmActionView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityScene/UIFarmAction.prefab"
}
return {UIFarmAction = UIFarmAction}
