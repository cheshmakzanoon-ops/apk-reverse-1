local FirstPayGetExpHistoryPopView = {
  Name = UIWindowNames.FirstPayGetExpHistoryPopView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstPayGetExpHistoryPopView.Ctrl.FirstPayGetExpHistoryPopViewCtrl"),
  View = require("UI.UIFirstPayGetExpHistoryPopView.View.FirstPayGetExpHistoryPopViewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/FirstPayGetExpHistoryPopView.prefab"
}
return {FirstPayGetExpHistoryPopView = FirstPayGetExpHistoryPopView}
