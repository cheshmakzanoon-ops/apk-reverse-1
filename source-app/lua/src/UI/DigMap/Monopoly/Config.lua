local UIMonopolyDigTreasure = {
  Name = UIWindowNames.UIMonopolyDigTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DigMap.Monopoly.Ctrl.UIMonopolyDigTreasureCtrl"),
  View = require("UI.DigMap.Monopoly.View.UIMonopolyDigTreasureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DigTreasureCommon/Monopoly/UIMonopolyDigTreasure.prefab"
}
return {UIMonopolyDigTreasure = UIMonopolyDigTreasure}
