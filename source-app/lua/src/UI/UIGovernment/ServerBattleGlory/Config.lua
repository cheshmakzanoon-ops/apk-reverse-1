local UIServerBattleGlory = {
  Name = UIWindowNames.UIServerBattleGlory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleGlory.Controller.UIServerBattleGloryCtrl"),
  View = require("UI.UIGovernment.ServerBattleGlory.View.UIServerBattleGloryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleGlory.prefab"
}
return {UIServerBattleGlory = UIServerBattleGlory}
