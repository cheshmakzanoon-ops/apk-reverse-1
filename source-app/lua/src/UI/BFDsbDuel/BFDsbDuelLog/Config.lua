local UIBFDsbDuelActLogView = {
  Name = UIWindowNames.UIBFDsbDuelActLogView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelLog.Controller.UIBFDsbDuelActLogCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelLog.View.UIBFDsbDuelActLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/Log/UIBFDsbDuelActOperateLogView.prefab"
}
return {UIBFDsbDuelActLogView = UIBFDsbDuelActLogView}
