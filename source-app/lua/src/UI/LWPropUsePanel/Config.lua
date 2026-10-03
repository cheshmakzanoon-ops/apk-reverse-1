local UIMain = {
  Name = UIWindowNames.LWPropUsePanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPropUsePanel.Controller.LWPropUsePanelCtrl"),
  View = require("UI.LWPropUsePanel.View.LWPropUsePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/LWPropUsePanel.prefab"
}
return {UIMain = UIMain}
