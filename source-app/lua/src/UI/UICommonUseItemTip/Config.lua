local UICommonUseItemTip = {
  Name = UIWindowNames.UICommonUseItemTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonUseItemTip.Controller.UICommonUseItemTipCtrl"),
  View = require("UI.UICommonUseItemTip.View.UICommonUseItemTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonUseItemTip.prefab"
}
return {UICommonUseItemTip = UICommonUseItemTip}
