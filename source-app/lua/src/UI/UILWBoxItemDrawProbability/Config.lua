local UILWBoxItemDrawProbability = {
  Name = UIWindowNames.UILWBoxItemDrawProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWBoxItemDrawProbability.Ctrl.UILWBoxItemDrawProbabilityCtrl"),
  View = require("UI.UILWBoxItemDrawProbability.View.UILWBoxItemDrawProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UILWBoxItemDrawProbability.prefab"
}
return {UILWBoxItemDrawProbability = UILWBoxItemDrawProbability}
