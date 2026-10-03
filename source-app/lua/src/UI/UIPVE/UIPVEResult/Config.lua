local UIPVEResult = {
  Name = UIWindowNames.UIPVEResult,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIPVE.UIPVEResult.Controller.UIPVEResultCtrl"),
  View = require("UI.UIPVE.UIPVEResult.View.UIPVEResultView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuidePioneerResult.prefab"
}
return {UIPVEResult = UIPVEResult}
