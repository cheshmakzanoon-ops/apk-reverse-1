local UILWAlHelp = {
  Name = UIWindowNames.UILWAlHelp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAlHelp.Controller.UILWAlHelpCtrl"),
  View = require("UI.UILWAlliance.UILWAlHelp.View.UILWAlHelpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlHelp.prefab"
}
return {UILWAlHelp = UILWAlHelp}
