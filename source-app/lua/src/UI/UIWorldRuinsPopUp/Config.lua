local UIWorldRuinsPopUp = {
  Name = UIWindowNames.UIWorldRuinsPopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldRuinsPopUp.Controller.UIWorldRuinsPopUpCtrl"),
  View = require("UI.UIWorldRuinsPopUp.View.UIWorldRuinsPopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIWorldRuinsPopUp.prefab"
}
return {UIWorldRuinsPopUp = UIWorldRuinsPopUp}
