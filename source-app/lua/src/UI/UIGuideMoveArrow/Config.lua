local UIGuideMoveArrow = {
  Name = UIWindowNames.UIGuideMoveArrow,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideMoveArrow.Controller.UIGuideMoveArrowCtrl"),
  View = require("UI.UIGuideMoveArrow.View.UIGuideMoveArrowView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideMoveArrow.prefab"
}
return {UIGuideMoveArrow = UIGuideMoveArrow}
