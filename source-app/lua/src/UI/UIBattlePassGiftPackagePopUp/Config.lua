local UIBattlePassGiftPackagePopUp = {
  Name = UIWindowNames.UIBattlePassGiftPackagePopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassGiftPackagePopUp.Controller.UIBattlePassGiftPackagePopUpCtrl"),
  View = require("UI.UIBattlePassGiftPackagePopUp.View.UIBattlePassGiftPackagePopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BattlePass/UIBattlePassGiftPackagePopUp.prefab"
}
return {UIBattlePassGiftPackagePopUp = UIBattlePassGiftPackagePopUp}
