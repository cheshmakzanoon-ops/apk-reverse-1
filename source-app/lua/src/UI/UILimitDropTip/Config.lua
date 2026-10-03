local UILimitDropTipView = {
  Name = UIWindowNames.UILimitDropTipView,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UILimitDropTip.Ctrl.UILimitDropTipCtrl"),
  View = require("UI.UILimitDropTip.View.UILimitDropTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILimitDrop_Prefab/UILimitDropTip.prefab",
  HideInBattle = true
}
return {UILimitDropTipView = UILimitDropTipView}
