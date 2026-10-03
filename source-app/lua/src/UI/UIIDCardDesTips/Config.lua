local UIIDCardDesTips = {
  Name = UIWindowNames.UIIDCardDesTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIIDCardDesTips.Controller.UIIDCardDesTipsCtrl"),
  View = require("UI.UIIDCardDesTips.View.UIIDCardDesTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIIDCardDesTips.prefab"
}
return {UIIDCardDesTips = UIIDCardDesTips}
