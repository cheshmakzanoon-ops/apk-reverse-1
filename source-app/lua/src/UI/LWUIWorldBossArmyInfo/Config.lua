local LWUIWorldBossArmyInfo = {
  Name = UIWindowNames.LWUIWorldBossArmyInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIWorldBossArmyInfo.Controller.LWUIWorldBossArmyInfoCtrl"),
  View = require("UI.LWUIWorldBossArmyInfo.View.LWUIWorldBossArmyInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/LWUIWorldBossArmyInfoView.prefab"
}
return {LWUIWorldBossArmyInfo = LWUIWorldBossArmyInfo}
