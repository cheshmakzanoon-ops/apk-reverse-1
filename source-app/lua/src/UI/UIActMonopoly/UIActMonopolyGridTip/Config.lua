local UIActMonopolyGridTip = {
  Name = UIWindowNames.UIActMonopolyGridTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyGridTip.Controller.UIActMonopolyGridTipCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyGridTip.View.UIActMonopolyGridTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyGridTip.prefab"
}
return {UIActMonopolyGridTip = UIActMonopolyGridTip}
