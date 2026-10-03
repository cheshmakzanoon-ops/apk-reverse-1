local UIBattlePassGiftPackagePopUp_Common = {
  Name = UIWindowNames.UIBattlePassGiftPackagePopUp_Common,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBattlePassGiftPackagePopUp_Common.Controller.UIBattlePassGiftPackagePopUp_CommonCtrl"),
  View = require("UI.UIBattlePassGiftPackagePopUp_Common.View.UIBattlePassGiftPackagePopUp_CommonView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Common/UIBattlePassNewYear/UIBattlePassGiftPackagePopUp_Common.prefab"
}
return {UIBattlePassGiftPackagePopUp_Common = UIBattlePassGiftPackagePopUp_Common}
