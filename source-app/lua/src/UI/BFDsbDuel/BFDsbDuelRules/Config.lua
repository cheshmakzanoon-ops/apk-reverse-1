local UIBFDsbDuelActRules = {
  Name = UIWindowNames.UIBFDsbDuelActRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelRules.Controller.UIBFDsbDuelActRulesCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelRules.View.UIBFDsbDuelActRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Rules/UIBFDsbDuelActRulesView.prefab"
}
return {UIBFDsbDuelActRules = UIBFDsbDuelActRules}
