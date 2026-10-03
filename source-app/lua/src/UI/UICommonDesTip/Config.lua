local UICommonDesTip = {
  Name = UIWindowNames.UICommonDesTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonDesTip.Controller.UICommonDesTipCtrl"),
  View = require("UI.UICommonDesTip.View.UICommonDesTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonDesTip.prefab"
}
return {UICommonDesTip = UICommonDesTip}
