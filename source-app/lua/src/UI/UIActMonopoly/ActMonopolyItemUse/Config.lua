local ActMonopolyItemUse = {
  Name = UIWindowNames.ActMonopolyItemUse,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.ActMonopolyItemUse.Controller.ActMonopolyItemUseCtrl"),
  View = require("UI.UIActMonopoly.ActMonopolyItemUse.View.ActMonopolyItemUseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/ActMonopolyItemUse.prefab"
}
return {ActMonopolyItemUse = ActMonopolyItemUse}
