local UIGuideArrow = {
  Name = UIWindowNames.UIGuideArrow,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideArrow.Controller.UIGuideArrowCtrl"),
  View = require("UI.UIGuideArrow.View.UIGuideArrowView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideArrow.prefab"
}
return {UIGuideArrow = UIGuideArrow}
