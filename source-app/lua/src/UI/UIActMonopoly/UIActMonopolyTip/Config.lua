local UIActMonopolyTip = {
  Name = UIWindowNames.UIActMonopolyTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyTip.Controller.UIActMonopolyTipCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyTip.View.UIActMonopolyTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIHalloweenActMonopolyTip.prefab"
}
return {UIActMonopolyTip = UIActMonopolyTip}
