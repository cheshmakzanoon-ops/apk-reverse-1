local UICommonSimpleTipView = {
  Name = UIWindowNames.UICommonSimpleTipView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.CommonTips.Ctrl.UICommonSimpleTipCtrl"),
  View = require("UI.UIDispatchTask.CommonTips.View.UICommonSimpleTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DispatchTreasure/UICommonSimpleTip.prefab"
}
return {UICommonSimpleTipView = UICommonSimpleTipView}
