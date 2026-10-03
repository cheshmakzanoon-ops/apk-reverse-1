local FirstPayGetExpHistoryTipsView = {
  Name = UIWindowNames.FirstPayGetExpHistoryTipsView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstPayGetExpTipView.Ctrl.FirstPayGetExpHistoryTipsViewCtrl"),
  View = require("UI.UIFirstPayGetExpTipView.View.FirstPayGetExpHistoryTipsViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/FirstPayGetExpHistoryTipsView.prefab"
}
return {FirstPayGetExpHistoryTipsView = FirstPayGetExpHistoryTipsView}
