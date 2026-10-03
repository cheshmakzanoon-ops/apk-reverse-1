local UILWAlSelectFlag = {
  Name = UIWindowNames.UILWAlSelectFlag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlSelectFlag.Controller.UILWAlSelectFlagCtrl"),
  View = require("UI.UILWAlliance.UILWAlSelectFlag.View.UILWAlSelectFlagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlSelectFlag.prefab"
}
return {UILWAlSelectFlag = UILWAlSelectFlag}
