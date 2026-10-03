local UICommonSingleMsgBar = {
  Name = UIWindowNames.UICommonSingleMsgBar,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonSingleMsgBar.Controller.UICommonSingleMsgBarCtrl"),
  View = require("UI.UICommonSingleMsgBar.View.UICommonSingleMsgBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonSingleMsgBar.prefab"
}
return {UICommonSingleMsgBar = UICommonSingleMsgBar}
