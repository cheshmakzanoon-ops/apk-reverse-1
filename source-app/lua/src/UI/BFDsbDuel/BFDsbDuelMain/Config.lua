local UIBFDsbDuelActMain = {
  Name = UIWindowNames.UIBFDsbDuelActMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelMain.Controller.UIBFDsbDuelActMainCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelMain.View.UIBFDsbDuelActMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/UIBFDsbDuelActMain.prefab",
  HideBack = true
}
return {UIBFDsbDuelActMain = UIBFDsbDuelActMain}
