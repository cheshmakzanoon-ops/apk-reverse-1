local UIGovernmentServerBattlePopup = {
  Name = UIWindowNames.UIGovernmentServerBattlePopup,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattlePopup.Controller.ServerBattleActivityPopupCtrl"),
  View = require("UI.UIGovernment.ServerBattlePopup.View.ServerBattleActivityPopupView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleActivityPopup.prefab"
}
return {UIGovernmentServerBattlePopup = UIGovernmentServerBattlePopup}
