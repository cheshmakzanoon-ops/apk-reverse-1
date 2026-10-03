local UIDecorationChoiceBox = {
  Name = UIWindowNames.UIDecorationChoiceBox,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDecorationChoiceBox.Controller.UIDecorationChoiceBoxCtrl"),
  View = require("UI.UIDecorationChoiceBox.View.UIDecorationChoiceBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DecorationChoiceBox/UIDecorationChoiceBox.prefab"
}
return {UIDecorationChoiceBox = UIDecorationChoiceBox}
