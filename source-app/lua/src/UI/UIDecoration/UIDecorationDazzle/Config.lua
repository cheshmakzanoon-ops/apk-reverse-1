local UIDecorationDazzleTips = {
  Name = UIWindowNames.UIDecorationDazzleTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDecoration.UIDecorationDazzle.Controller.UIDecorationDazzleTipsCtrl"),
  View = require("UI.UIDecoration.UIDecorationDazzle.View.UIDecorationDazzleTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIDecorationDazzleTips.prefab"
}
return {UIDecorationDazzleTips = UIDecorationDazzleTips}
