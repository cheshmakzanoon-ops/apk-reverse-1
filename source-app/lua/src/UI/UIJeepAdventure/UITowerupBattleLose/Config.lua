local UITowerupBattleLose = {
  Name = UIWindowNames.UITowerupBattleLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJeepAdventure.UITowerupBattleLose.Controller.UITowerupBattleLoseCtrl"),
  View = require("UI.UIJeepAdventure.UITowerupBattleLose.View.UITowerupBattleLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleLosePanel.prefab"
}
return {UITowerupBattleLose = UITowerupBattleLose}
