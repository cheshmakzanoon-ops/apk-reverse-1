local UIMailNew = {
  Name = UIWindowNames.UIMailNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailMainPanel.Controller.UIMailMainPanelCtrl"),
  View = require("UI.UIMailNew.UIMailMainPanel.View.UIMailMainPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/UIMailMainPanel.prefab"
}
return {UIMailNew = UIMailNew}
