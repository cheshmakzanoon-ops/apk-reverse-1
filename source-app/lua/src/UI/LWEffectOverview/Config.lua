local UILWResourceLack = {
  Name = UIWindowNames.LWEffectOverview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWEffectOverview.Controller.LWEffectOverviewCtrl"),
  View = require("UI.LWEffectOverview.View.LWEffectOverviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWEffectOverview/LWEffectOverview.prefab"
}
return {UILWResourceLack = UILWResourceLack}
