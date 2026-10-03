local UIBattlePassNewYearGiftPackagePopUp_Common = {
  Name = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp_Common,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassNewYearGiftPackagePopUp_Common.Controller.UIBattlePassNewYearGiftPackagePopUp_CommonCtrl"),
  View = require("UI.UIBattlePassNewYearGiftPackagePopUp_Common.View.UIBattlePassNewYearGiftPackagePopUp_CommonView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Common/UIBattlePassNewYear/UIBattlePassGiftPackagePopUpNewYear_Common.prefab"
}
return {UIBattlePassNewYearGiftPackagePopUp_Common = UIBattlePassNewYearGiftPackagePopUp_Common}
