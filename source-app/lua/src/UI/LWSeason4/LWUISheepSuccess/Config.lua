local LWUISheepSuccess = {
  Name = UIWindowNames.LWUISheepSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWUISheepSuccess.Controller.LWUISheepSuccessCtrl"),
  View = require("UI.LWSeason4.LWUISheepSuccess.View.LWUISheepSuccessView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepSuccess.prefab",
  CustomKeyCodeEscape = true
}
return {LWUISheepSuccess = LWUISheepSuccess}
