local UIActMonopolyTip2 = {
  Name = UIWindowNames.UIActMonopolyTip2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyTip2.Controller.UIActMonopolyTip2Ctrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyTip2.View.UIActMonopolyTip2View"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyTip2.prefab"
}
return {UIActMonopolyTip2 = UIActMonopolyTip2}
