local UICommonItemProbability = {
  Name = UIWindowNames.UICommonItemProbability,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonItemProbability.Controller.UICommonItemProbabilityCtrl"),
  View = require("UI.UICommonItemProbability.View.UICommonItemProbabilityView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonItemProbability.prefab"
}
return {UICommonItemProbability = UICommonItemProbability}
