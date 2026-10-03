local UIBFDsbDuelActGetFinalReward = {
  Name = UIWindowNames.UIBFDsbDuelActGetFinalReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BFDsbDuel.BFDsbDuelGetFinalReward.Controller.UIBFDsbDuelActGetFinalRewardCtrl"),
  View = require("UI.BFDsbDuel.BFDsbDuelGetFinalReward.View.UIBFDsbDuelActGetFinalRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/FinalReward/UIBFDsbDuelActFinalReward.prefab"
}
return {UIBFDsbDuelActGetFinalReward = UIBFDsbDuelActGetFinalReward}
