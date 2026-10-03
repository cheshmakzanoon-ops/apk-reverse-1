local UITCChoiceBox = {
  Name = UIWindowNames.UITCChoiceBox,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCChoiceBox.Ctrl.UITCChoiceBoxCtrl"),
  View = require("UI.LWUITC.UITCChoiceBox.View.UITCChoiceBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/ChoiceBox/UITCChoiceBox.prefab"
}
return {UITCChoiceBox = UITCChoiceBox}
