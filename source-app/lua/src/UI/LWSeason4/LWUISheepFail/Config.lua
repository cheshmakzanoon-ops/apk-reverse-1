local LWUISheepFail = {
  Name = UIWindowNames.LWUISheepFail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWUISheepFail.Controller.LWUISheepFailCtrl"),
  View = require("UI.LWSeason4.LWUISheepFail.View.LWUISheepFailView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepFail.prefab",
  CustomKeyCodeEscape = true
}
return {LWUISheepFail = LWUISheepFail}
