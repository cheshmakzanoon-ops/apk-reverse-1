local UILWTrainUpgradeMain = {
  Name = UIWindowNames.UILWDominatorTrainUpgradeMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDominator.Train.TrainUpgradeMain.Ctrl.UILWDominatorTrainMainUpgradeCtrl"),
  View = require("UI.UILWDominator.Train.TrainUpgradeMain.View.UILWDominatorTrainMainUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorTrainMainUpgrade.prefab"
}
return {UILWTrainUpgradeMain = UILWTrainUpgradeMain}
