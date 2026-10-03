local UIMineCaveTips = {
  Name = UIWindowNames.UIMineCaveTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMineCaveTips.Controller.UIMineCaveTipsCtrl"),
  View = require("UI.UIMineCaveTips.View.UIMineCaveTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMineCave/UIMineCaveTips.prefab"
}
return {UIMineCaveTips = UIMineCaveTips}
