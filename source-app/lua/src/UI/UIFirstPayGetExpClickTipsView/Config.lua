local FirstPayGetExpClickTipsView = {
  Name = UIWindowNames.FirstPayGetExpClickTipsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstPayGetExpClickTipsView.Ctrl.FirstPayGetExpClickTipsViewCtrl"),
  View = require("UI.UIFirstPayGetExpClickTipsView.View.FirstPayGetExpClickTipsViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/FirstPayGetExpClickTipsView.prefab"
}
return {FirstPayGetExpClickTipsView = FirstPayGetExpClickTipsView}
