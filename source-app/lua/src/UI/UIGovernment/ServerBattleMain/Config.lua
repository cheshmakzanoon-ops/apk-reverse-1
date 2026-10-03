local UIGovernmentServerBattleMain = {
  Name = UIWindowNames.UIGovernmentServerBattleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleMain.Controller.ServerBattleMainCtrl"),
  View = require("UI.UIGovernment.ServerBattleMain.View.ServerBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleMain.prefab"
}
return {UIGovernmentServerBattleMain = UIGovernmentServerBattleMain}
