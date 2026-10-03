local UILWMilitaryCampPanel = {
  Name = UIWindowNames.UILWMilitaryCampPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWMilitaryCampPanel.Controller.UILWMilitaryCampPanelCtrl"),
  View = require("UI.UILWMilitaryCampPanel.View.UILWMilitaryCampPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWMilitaryCamp/UIMilitaryCampPanel.prefab"
}
return {UILWMilitaryCampPanel = UILWMilitaryCampPanel}
