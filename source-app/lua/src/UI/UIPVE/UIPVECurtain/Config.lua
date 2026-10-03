local UIPVECurtain = {
  Name = UIWindowNames.UIPVECurtain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVECurtain.Controller.UIPVECurtainCtrl"),
  View = require("UI.UIPVE.UIPVECurtain.View.UIPVECurtainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVECurtain.prefab"
}
return {UIPVECurtain = UIPVECurtain}
