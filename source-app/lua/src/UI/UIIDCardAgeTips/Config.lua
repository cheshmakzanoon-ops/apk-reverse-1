local UIIDCardAgeTips = {
  Name = UIWindowNames.UIIDCardAgeTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIIDCardAgeTips.Controller.UIIDCardAgeTipsCtrl"),
  View = require("UI.UIIDCardAgeTips.View.UIIDCardAgeTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIIDCardAgeTips.prefab"
}
return {UIIDCardAgeTips = UIIDCardAgeTips}
