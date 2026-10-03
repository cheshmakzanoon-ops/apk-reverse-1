local UINoticeTips = {
  Name = UIWindowNames.UINoticeTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UINoticeTips.Controller.UINoticeTipsCtrl"),
  View = require("UI.UINoticeTips.View.UINoticeTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UINoticeTips.prefab"
}
return {UINoticeTips = UINoticeTips}
