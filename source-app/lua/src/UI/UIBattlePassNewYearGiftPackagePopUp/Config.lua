local UIBattlePassNewYearGiftPackagePopUp = {
  Name = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassNewYearGiftPackagePopUp.Controller.UIBattlePassNewYearGiftPackagePopUpCtrl"),
  View = require("UI.UIBattlePassNewYearGiftPackagePopUp.View.UIBattlePassNewYearGiftPackagePopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIBattlePassGiftPackagePopUpNewYear.prefab"
}
return {UIBattlePassNewYearGiftPackagePopUp = UIBattlePassNewYearGiftPackagePopUp}
