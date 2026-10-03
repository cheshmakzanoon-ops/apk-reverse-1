local LWUIGoldTreeThird = {
  Name = UIWindowNames.LWUIGoldTreeThird,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4/LWUIGoldTreeThird.Controller.LWUIGoldTreeThirdCtrl"),
  View = require("UI.LWSeason4/LWUIGoldTreeThird.View.LWUIGoldTreeThirdView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTreeThird/LWUIGoldTreeThird.prefab",
  HideBack = false,
  CustomKeyCodeEscape = true
}
return {LWUIGoldTreeThird = LWUIGoldTreeThird}
