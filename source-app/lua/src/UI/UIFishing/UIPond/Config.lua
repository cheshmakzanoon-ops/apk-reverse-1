local UIPond = {
  Name = UIWindowNames.UIPond,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIPond.UIPondCtrl"),
  View = require("UI.UIFishing.UIPond.UIPondView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIPond.prefab",
  HideBack = true
}
return {UIPond = UIPond}
