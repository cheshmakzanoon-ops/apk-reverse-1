local LWUIMastery = {
  Name = UIWindowNames.LWUIMastery,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMastery.Controller.LWUIMasteryCtrl"),
  View = require("UI.LWUIMastery.View.LWUIMasteryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMastery.prefab",
  HideBack = true
}
return {LWUIMastery = LWUIMastery}
