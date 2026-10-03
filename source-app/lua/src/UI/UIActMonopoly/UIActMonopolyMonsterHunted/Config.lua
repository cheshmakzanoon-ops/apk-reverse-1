local UIActMonopolyMonsterHunted = {
  Name = UIWindowNames.UIActMonopolyMonsterHunted,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyMonsterHunted.Controller.UIActMonopolyMonsterHuntedCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyMonsterHunted.View.UIActMonopolyMonsterHuntedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyMonsterHunted.prefab"
}
return {UIActMonopolyMonsterHunted = UIActMonopolyMonsterHunted}
