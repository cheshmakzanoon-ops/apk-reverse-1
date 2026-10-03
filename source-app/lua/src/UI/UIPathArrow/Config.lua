local UIPathArrow = {
  Name = UIWindowNames.UIPathArrow,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIPathArrow.Controller.UIPathArrowCtrl"),
  View = require("UI.UIPathArrow.View.UIPathArrowView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIPathArrow.prefab"
}
return {UIPathArrow = UIPathArrow}
