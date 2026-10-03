local UIDecorationUseChange = {
  Name = UIWindowNames.UIDecorationUseChange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecorationUseChange.Controller.UIDecorationUseChangeCtrl"),
  View = require("UI.UIDecorationUseChange.View.UIDecorationUseChangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DecorationChoiceBox/UIDecorationUseChange.prefab"
}
return {UIDecorationUseChange = UIDecorationUseChange}
