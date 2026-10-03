local UICommonMessageSpecialBar = {
  Name = UIWindowNames.UICommonMessageSpecialBar,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonMessageSpecialBar.Controller.UICommonMessageSpecialBarCtrl"),
  View = require("UI.UICommonMessageSpecialBar.View.UICommonMessageSpecialBarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageSpecialBar.prefab"
}
return {UICommonMessageSpecialBar = UICommonMessageSpecialBar}
