local UIArrow = {
  Name = UIWindowNames.UIArrow,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIArrow.Controller.UIArrowCtrl"),
  View = require("UI.UIArrow.View.UIArrowView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIArrow.prefab"
}
return {UIArrow = UIArrow}
