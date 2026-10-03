local LWUIMasteryCenterTab = {
  Name = UIWindowNames.LWUIMasteryCenterTab,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasteryCenterTab.Ctrl.LWUIMasteryCenterTabCtrl"),
  View = require("UI.LWUIMasteryCenterTab.View.LWUIMasteryCenterTabView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasteryCenterTab.prefab",
  HideBack = true
}
return {LWUIMasteryCenterTab = LWUIMasteryCenterTab}
