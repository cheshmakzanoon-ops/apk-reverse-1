local LWUIGoldTreeHelp = {
  Name = UIWindowNames.LWUIGoldTreeHelp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4/LWUIGoldTreeHelp.Controller.LWUIGoldTreeHelpCtrl"),
  View = require("UI.LWSeason4/LWUIGoldTreeHelp.View.LWUIGoldTreeHelpView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTreeThird/LWUIGoldTreeHelp.prefab",
  HideBack = false,
  CustomKeyCodeEscape = false
}
return {LWUIGoldTreeHelp = LWUIGoldTreeHelp}
