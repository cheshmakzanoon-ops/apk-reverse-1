local UIPVESelectDiff = {
  Name = UIWindowNames.UIPVESelectDiff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVESelectDiff.Controller.UIPVESelectDiffCtrl"),
  View = require("UI.UIPVE.UIPVESelectDiff.View.UIPVESelectDiffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectDiff.prefab"
}
return {UIPVESelectDiff = UIPVESelectDiff}
