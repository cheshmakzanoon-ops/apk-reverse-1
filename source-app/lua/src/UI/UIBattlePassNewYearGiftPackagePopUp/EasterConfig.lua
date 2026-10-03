local UIBattlePassEasterGiftPackagePopUp = {
  Name = UIWindowNames.UIBattlePassEasterGiftPackagePopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassNewYearGiftPackagePopUp.Controller.UIBattlePassEasterGiftPackagePopUpCtrl"),
  View = require("UI.UIBattlePassNewYearGiftPackagePopUp.View.UIBattlePassNewYearGiftPackagePopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassGiftPackagePopUpEaster.prefab"
}
return {UIBattlePassEasterGiftPackagePopUp = UIBattlePassEasterGiftPackagePopUp}
