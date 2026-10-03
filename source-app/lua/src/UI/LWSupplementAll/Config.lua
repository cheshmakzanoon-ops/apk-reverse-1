local UILWSupplementAll = {
  Name = UIWindowNames.UILWSupplementAll,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSupplementAll.Controller.LWUISupplementAllCtrl"),
  View = require("UI.LWSupplementAll.View.LWUISupplementAllView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWResource/LWSupplementAllPanel.prefab"
}
return {UILWSupplementAll = UILWSupplementAll}
