local UIResSupport = {
  Name = UIWindowNames.UIResSupport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIResSupport.Controller.UIResSupportCtrl"),
  View = require("UI.UIResSupport.View.UIResSupportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceResAssist.prefab"
}
return {UIResSupport = UIResSupport}
