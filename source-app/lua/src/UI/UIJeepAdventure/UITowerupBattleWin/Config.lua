local UITowerupBattleWin = {
  Name = UIWindowNames.UITowerupBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIJeepAdventure.UITowerupBattleWin.Controller.UITowerupBattleWinCtrl"),
  View = require("UI.UIJeepAdventure.UITowerupBattleWin.View.UITowerupBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIJeepAdventure/LWTowerupBattleWinPanel.prefab"
}
return {UITowerupBattleWin = UITowerupBattleWin}
