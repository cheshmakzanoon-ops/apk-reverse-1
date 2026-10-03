local UICommonPanelBtn = {
  Name = UIWindowNames.UICommonPanelBtn,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonPanelBtn.Controller.UICommonPanelBtnCtrl"),
  View = require("UI.UICommonPanelBtn.View.UICommonPanelBtnView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIPanelBtn.prefab"
}
return {UICommonPanelBtn = UICommonPanelBtn}
